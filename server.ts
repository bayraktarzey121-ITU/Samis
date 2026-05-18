import express from "express";
import path from "path";
import { createServer as createViteServer } from "vite";
import { fileURLToPath } from "url";
import dotenv from "dotenv";
import { createClient } from "@supabase/supabase-js";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function startServer() {
  const app = express();
  const PORT = Number(process.env.PORT || 3000);
  const supabaseUrl = process.env.VITE_SUPABASE_URL;
  const supabaseServiceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  const supabase =
    supabaseUrl && supabaseServiceRoleKey
      ? createClient(supabaseUrl, supabaseServiceRoleKey, {
          auth: { persistSession: false, autoRefreshToken: false },
        })
      : null;

  app.use(express.json());

  const requireBackend = () => {
    if (!supabase) {
      throw new Error("Supabase server credentials are missing. Set VITE_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY.");
    }

    return supabase;
  };

  // API Routes
  app.get("/api/health", (req, res) => {
    res.json({ status: "ok", system: "SAMIS", version: "1.0.0" });
  });

  app.get("/api/dashboard/stats", async (req, res) => {
    try {
      const db = requireBackend();
      const now = new Date().toISOString();
      const [animals, adopted, complaints, vaccinations, facilities] = await Promise.all([
        db.from("animals").select("animal_id", { count: "exact", head: true }),
        db.from("adoptions").select("adoption_id", { count: "exact", head: true }).in("status", ["Approved", "Completed"]),
        db.from("complaints").select("complaint_id", { count: "exact", head: true }).in("status", ["Open", "InProgress"]),
        db.from("vaccinations").select("vaccination_id", { count: "exact", head: true }).lt("next_due_date", now),
        db.from("facilities").select("capacity,current_occupancy").eq("is_active", true),
      ]);

      const error = animals.error || adopted.error || complaints.error || vaccinations.error || facilities.error;
      if (error) throw error;

      const shelterCapacity = (facilities.data ?? []).reduce((highest, facility) => {
        const capacity = facility.capacity > 0 ? Math.round((facility.current_occupancy / facility.capacity) * 100) : 0;
        return Math.max(highest, capacity);
      }, 0);

      res.json({
        totalAnimals: animals.count ?? 0,
        adopted: adopted.count ?? 0,
        openComplaints: complaints.count ?? 0,
        shelterCapacity,
        overdueVaccinations: vaccinations.count ?? 0,
      });
    } catch (error) {
      res.status(500).json({ error: error instanceof Error ? error.message : "Dashboard stats failed" });
    }
  });

  // Animal sterilization (CNVR Logic)
  app.post("/api/animals/:id/sterilize", async (req, res) => {
    try {
      const db = requireBackend();
      const { id } = req.params;
      const { data, error } = await db
        .from("animals")
        .update({ sterilization_status: true, status: "Released", updated_at: new Date().toISOString() })
        .eq("animal_id", id)
        .select("animal_id, sterilization_status, status")
        .single();

      if (error) throw error;

      res.json({
        success: true,
        action: "CNVR_COMPLETED",
        animal: data,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      res.status(500).json({ error: error instanceof Error ? error.message : "Sterilization update failed" });
    }
  });

  // Complaint Assignment Logic
  app.post("/api/complaints/:id/assign", async (req, res) => {
    try {
      const db = requireBackend();
      const { id } = req.params;
      const { staff_id } = req.body;

      const { data, error } = await db
        .from("complaints")
        .update({ assigned_staff_id: staff_id, status: "InProgress" })
        .eq("complaint_id", id)
        .select("complaint_id, assigned_staff_id, status")
        .single();

      if (error) throw error;

      res.json({ success: true, complaint: data });
    } catch (error) {
      res.status(500).json({ error: error instanceof Error ? error.message : "Complaint assignment failed" });
    }
  });

  // Vite middleware for development
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    // Production serving
    const distPath = path.join(process.cwd(), "dist");
    app.use(express.static(distPath));
    app.get("*", (req, res) => {
      res.sendFile(path.join(distPath, "index.html"));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`SAMIS Server running on http://localhost:${PORT}`);
  });
}

startServer();
