-- SAMIS mock seed data.
-- Uses fixed UUIDs and nullable auth.users references so it can run before auth accounts exist.

INSERT INTO municipalities (mun_id, name, city, district, total_capacity, contact_email, contact_phone)
VALUES
  ('00000000-0000-0000-0000-000000000101', 'Besiktas Belediyesi', 'Istanbul', 'Besiktas', 250, 'samis@besiktas.bel.tr', '+90 212 000 00 01'),
  ('00000000-0000-0000-0000-000000000102', 'Kadikoy Belediyesi', 'Istanbul', 'Kadikoy', 320, 'samis@kadikoy.bel.tr', '+90 216 000 00 02'),
  ('00000000-0000-0000-0000-000000000103', 'Cankaya Belediyesi', 'Ankara', 'Cankaya', 280, 'samis@cankaya.bel.tr', '+90 312 000 00 03'),
  ('00000000-0000-0000-0000-000000000104', 'Konak Belediyesi', 'Izmir', 'Konak', 230, 'samis@konak.bel.tr', '+90 232 000 00 04'),
  ('00000000-0000-0000-0000-000000000105', 'Muratpasa Belediyesi', 'Antalya', 'Muratpasa', 210, 'samis@muratpasa.bel.tr', '+90 242 000 00 05'),
  ('00000000-0000-0000-0000-000000000106', 'Nilufer Belediyesi', 'Bursa', 'Nilufer', 260, 'samis@nilufer.bel.tr', '+90 224 000 00 06'),
  ('00000000-0000-0000-0000-000000000107', 'Tepebasi Belediyesi', 'Eskisehir', 'Tepebasi', 190, 'samis@tepebasi.bel.tr', '+90 222 000 00 07'),
  ('00000000-0000-0000-0000-000000000108', 'Atakum Belediyesi', 'Samsun', 'Atakum', 170, 'samis@atakum.bel.tr', '+90 362 000 00 08'),
  ('00000000-0000-0000-0000-000000000109', 'Ortahisar Belediyesi', 'Trabzon', 'Ortahisar', 150, 'samis@ortahisar.bel.tr', '+90 462 000 00 09'),
  ('00000000-0000-0000-0000-000000000110', 'Sahinbey Belediyesi', 'Gaziantep', 'Sahinbey', 300, 'samis@sahinbey.bel.tr', '+90 342 000 00 10')
ON CONFLICT (mun_id) DO UPDATE SET
  name = EXCLUDED.name,
  city = EXCLUDED.city,
  district = EXCLUDED.district,
  total_capacity = EXCLUDED.total_capacity,
  contact_email = EXCLUDED.contact_email,
  contact_phone = EXCLUDED.contact_phone;

INSERT INTO facilities (facility_id, name, facility_type, capacity, current_occupancy, address, municipality_id, alert_threshold)
VALUES
  ('00000000-0000-0000-0000-000000000201', 'Besiktas Merkez Barinagi', 'shelter', 120, 89, 'Besiktas, Istanbul', '00000000-0000-0000-0000-000000000101', 80),
  ('00000000-0000-0000-0000-000000000202', 'Fikirtepe Rehabilitasyon Merkezi', 'rehabilitation', 150, 118, 'Kadikoy, Istanbul', '00000000-0000-0000-0000-000000000102', 82),
  ('00000000-0000-0000-0000-000000000203', 'Dikmen Veteriner Klinigi', 'vet_clinic', 45, 19, 'Cankaya, Ankara', '00000000-0000-0000-0000-000000000103', 75),
  ('00000000-0000-0000-0000-000000000204', 'Konak Sahil Barinagi', 'shelter', 100, 76, 'Konak, Izmir', '00000000-0000-0000-0000-000000000104', 80),
  ('00000000-0000-0000-0000-000000000205', 'Lara Gecici Bakimevi', 'shelter', 90, 62, 'Muratpasa, Antalya', '00000000-0000-0000-0000-000000000105', 78),
  ('00000000-0000-0000-0000-000000000206', 'Nilufer Hayvan Hastanesi', 'vet_clinic', 55, 23, 'Nilufer, Bursa', '00000000-0000-0000-0000-000000000106', 80),
  ('00000000-0000-0000-0000-000000000207', 'Tepebasi Rehabilitasyon Merkezi', 'rehabilitation', 95, 71, 'Tepebasi, Eskisehir', '00000000-0000-0000-0000-000000000107', 83),
  ('00000000-0000-0000-0000-000000000208', 'Atakum Sahil Barinagi', 'shelter', 80, 58, 'Atakum, Samsun', '00000000-0000-0000-0000-000000000108', 80),
  ('00000000-0000-0000-0000-000000000209', 'Ortahisar Bakim Noktasi', 'rehabilitation', 70, 46, 'Ortahisar, Trabzon', '00000000-0000-0000-0000-000000000109', 85),
  ('00000000-0000-0000-0000-000000000210', 'Sahinbey Merkez Barinagi', 'shelter', 130, 94, 'Sahinbey, Gaziantep', '00000000-0000-0000-0000-000000000110', 80)
ON CONFLICT (facility_id) DO UPDATE SET
  name = EXCLUDED.name,
  facility_type = EXCLUDED.facility_type,
  capacity = EXCLUDED.capacity,
  current_occupancy = EXCLUDED.current_occupancy,
  address = EXCLUDED.address,
  municipality_id = EXCLUDED.municipality_id,
  alert_threshold = EXCLUDED.alert_threshold,
  is_active = TRUE;

INSERT INTO animals (animal_id, microchip_id, name, species, breed, age_estimate, sex, color_markings, sterilization_status, status, aggressive_flag, municipality_id, current_facility_id, registered_by, notes)
VALUES
  ('00000000-0000-0000-0000-000000000301', '900215000543211', 'Zeytin', 'dog', 'Golden mix', 4, 'female', 'gold coat, white chest', TRUE, 'In Shelter', FALSE, '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000201', NULL, 'Friendly and leash trained.'),
  ('00000000-0000-0000-0000-000000000302', '900215000543212', 'Pamuk', 'cat', 'Tabby', 2, 'female', 'gray tabby', TRUE, 'Adopted', FALSE, '00000000-0000-0000-0000-000000000102', NULL, NULL, 'Completed adoption follow-up.'),
  ('00000000-0000-0000-0000-000000000303', '900215000543213', 'Max', 'dog', 'Terrier mix', 3, 'male', 'black and tan', FALSE, 'In Shelter', FALSE, '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000203', NULL, 'Recovering after intake check.'),
  ('00000000-0000-0000-0000-000000000304', '900215000543214', 'Gofret', 'dog', 'Mixed', 5, 'male', 'brown brindle', TRUE, 'Active', FALSE, '00000000-0000-0000-0000-000000000104', NULL, NULL, 'Released to known feeding area.'),
  ('00000000-0000-0000-0000-000000000305', '900215000543215', 'Mavi', 'cat', 'Domestic shorthair', 1.5, 'male', 'white with blue collar mark', FALSE, 'In Shelter', FALSE, '00000000-0000-0000-0000-000000000105', '00000000-0000-0000-0000-000000000205', NULL, 'Pending sterilization appointment.'),
  ('00000000-0000-0000-0000-000000000306', '900215000543216', 'Karamel', 'dog', 'Anatolian shepherd mix', 6, 'female', 'tan coat', TRUE, 'Released', FALSE, '00000000-0000-0000-0000-000000000106', NULL, NULL, 'Returned after CNVR.'),
  ('00000000-0000-0000-0000-000000000307', '900215000543217', 'Limon', 'cat', 'Calico', 4, 'female', 'orange black white', TRUE, 'In Shelter', FALSE, '00000000-0000-0000-0000-000000000107', '00000000-0000-0000-0000-000000000207', NULL, 'Mild respiratory monitoring.'),
  ('00000000-0000-0000-0000-000000000308', '900215000543218', 'Duman', 'dog', 'Husky mix', 2.5, 'male', 'gray and white', FALSE, 'Active', TRUE, '00000000-0000-0000-0000-000000000108', NULL, NULL, 'Requires experienced handler.'),
  ('00000000-0000-0000-0000-000000000309', '900215000543219', 'Findik', 'cat', 'Domestic longhair', 7, 'male', 'brown longhair', TRUE, 'In Shelter', FALSE, '00000000-0000-0000-0000-000000000109', '00000000-0000-0000-0000-000000000209', NULL, 'Senior diet recommended.'),
  ('00000000-0000-0000-0000-000000000310', '900215000543220', 'Simit', 'dog', 'Mixed', 1, 'female', 'cream coat', FALSE, 'In Shelter', FALSE, '00000000-0000-0000-0000-000000000110', '00000000-0000-0000-0000-000000000210', NULL, 'Puppy socialization group.')
ON CONFLICT (animal_id) DO UPDATE SET
  microchip_id = EXCLUDED.microchip_id,
  name = EXCLUDED.name,
  species = EXCLUDED.species,
  breed = EXCLUDED.breed,
  age_estimate = EXCLUDED.age_estimate,
  sex = EXCLUDED.sex,
  color_markings = EXCLUDED.color_markings,
  sterilization_status = EXCLUDED.sterilization_status,
  status = EXCLUDED.status,
  aggressive_flag = EXCLUDED.aggressive_flag,
  municipality_id = EXCLUDED.municipality_id,
  current_facility_id = EXCLUDED.current_facility_id,
  registered_by = NULL,
  notes = EXCLUDED.notes;

INSERT INTO animal_location_history (history_id, animal_id, event_type, event_date, location_lat, location_lng, facility_id, from_facility_id, to_facility_id, recorded_by, notes)
VALUES
  ('00000000-0000-0000-0000-000000000401', '00000000-0000-0000-0000-000000000301', 'Catch', '2026-01-05 09:30:00+03', 41.0433, 29.0094, '00000000-0000-0000-0000-000000000201', NULL, '00000000-0000-0000-0000-000000000201', NULL, 'Found near Besiktas ferry pier.'),
  ('00000000-0000-0000-0000-000000000402', '00000000-0000-0000-0000-000000000302', 'Adoption', '2026-01-12 15:00:00+03', 40.9901, 29.0288, NULL, '00000000-0000-0000-0000-000000000202', NULL, NULL, 'Moved to adopter after approval.'),
  ('00000000-0000-0000-0000-000000000403', '00000000-0000-0000-0000-000000000303', 'Transfer', '2026-01-18 11:15:00+03', 39.8909, 32.8425, '00000000-0000-0000-0000-000000000203', NULL, '00000000-0000-0000-0000-000000000203', NULL, 'Transferred for vet observation.'),
  ('00000000-0000-0000-0000-000000000404', '00000000-0000-0000-0000-000000000304', 'Release', '2026-02-02 10:20:00+03', 38.4189, 27.1287, NULL, '00000000-0000-0000-0000-000000000204', NULL, NULL, 'Released after vaccination.'),
  ('00000000-0000-0000-0000-000000000405', '00000000-0000-0000-0000-000000000305', 'Catch', '2026-02-09 08:45:00+03', 36.8841, 30.7056, '00000000-0000-0000-0000-000000000205', NULL, '00000000-0000-0000-0000-000000000205', NULL, 'Kitten reported near schoolyard.'),
  ('00000000-0000-0000-0000-000000000406', '00000000-0000-0000-0000-000000000306', 'Release', '2026-02-14 13:10:00+03', 40.2136, 28.9844, NULL, '00000000-0000-0000-0000-000000000206', NULL, NULL, 'Returned to Nilufer park feeding route.'),
  ('00000000-0000-0000-0000-000000000407', '00000000-0000-0000-0000-000000000307', 'Transfer', '2026-03-01 16:25:00+03', 39.7667, 30.5256, '00000000-0000-0000-0000-000000000207', '00000000-0000-0000-0000-000000000203', '00000000-0000-0000-0000-000000000207', NULL, 'Moved for quarantine space.'),
  ('00000000-0000-0000-0000-000000000408', '00000000-0000-0000-0000-000000000308', 'Relocation', '2026-03-07 09:05:00+03', 41.2867, 36.3300, NULL, NULL, NULL, NULL, 'Relocated away from school entrance.'),
  ('00000000-0000-0000-0000-000000000409', '00000000-0000-0000-0000-000000000309', 'Catch', '2026-03-13 12:35:00+03', 41.0027, 39.7168, '00000000-0000-0000-0000-000000000209', NULL, '00000000-0000-0000-0000-000000000209', NULL, 'Senior cat intake.'),
  ('00000000-0000-0000-0000-000000000410', '00000000-0000-0000-0000-000000000310', 'Catch', '2026-03-20 14:50:00+03', 37.0662, 37.3833, '00000000-0000-0000-0000-000000000210', NULL, '00000000-0000-0000-0000-000000000210', NULL, 'Young dog found near market.')
ON CONFLICT (history_id) DO UPDATE SET
  animal_id = EXCLUDED.animal_id,
  event_type = EXCLUDED.event_type,
  event_date = EXCLUDED.event_date,
  location_lat = EXCLUDED.location_lat,
  location_lng = EXCLUDED.location_lng,
  facility_id = EXCLUDED.facility_id,
  from_facility_id = EXCLUDED.from_facility_id,
  to_facility_id = EXCLUDED.to_facility_id,
  recorded_by = NULL,
  notes = EXCLUDED.notes;

INSERT INTO vaccinations (vaccination_id, animal_id, vet_id, vaccine_type, administered_at, next_due_date, batch_no, facility_id, notes)
VALUES
  ('00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000301', NULL, 'Rabies', '2026-01-06 10:00:00+03', '2027-01-06 10:00:00+03', 'RAB-26-001', '00000000-0000-0000-0000-000000000201', 'Annual rabies vaccine.'),
  ('00000000-0000-0000-0000-000000000502', '00000000-0000-0000-0000-000000000302', NULL, 'FVRCP', '2026-01-10 11:00:00+03', '2027-01-10 11:00:00+03', 'CAT-26-002', '00000000-0000-0000-0000-000000000202', 'Core feline vaccine.'),
  ('00000000-0000-0000-0000-000000000503', '00000000-0000-0000-0000-000000000303', NULL, 'DHPP', '2026-01-19 12:00:00+03', '2027-01-19 12:00:00+03', 'DOG-26-003', '00000000-0000-0000-0000-000000000203', 'Canine core vaccine.'),
  ('00000000-0000-0000-0000-000000000504', '00000000-0000-0000-0000-000000000304', NULL, 'Rabies', '2026-02-01 09:45:00+03', '2027-02-01 09:45:00+03', 'RAB-26-004', '00000000-0000-0000-0000-000000000204', 'Given before release.'),
  ('00000000-0000-0000-0000-000000000505', '00000000-0000-0000-0000-000000000305', NULL, 'FVRCP', '2026-02-10 10:30:00+03', '2026-05-10 10:30:00+03', 'CAT-26-005', '00000000-0000-0000-0000-000000000205', 'Booster due after intake series.'),
  ('00000000-0000-0000-0000-000000000506', '00000000-0000-0000-0000-000000000306', NULL, 'Rabies', '2026-02-13 14:00:00+03', '2027-02-13 14:00:00+03', 'RAB-26-006', '00000000-0000-0000-0000-000000000206', 'CNVR vaccine record.'),
  ('00000000-0000-0000-0000-000000000507', '00000000-0000-0000-0000-000000000307', NULL, 'FVRCP', '2026-03-02 11:10:00+03', '2027-03-02 11:10:00+03', 'CAT-26-007', '00000000-0000-0000-0000-000000000207', 'Respiratory symptoms monitored.'),
  ('00000000-0000-0000-0000-000000000508', '00000000-0000-0000-0000-000000000308', NULL, 'DHPP', '2026-03-08 13:15:00+03', '2027-03-08 13:15:00+03', 'DOG-26-008', '00000000-0000-0000-0000-000000000208', 'Administered during field operation.'),
  ('00000000-0000-0000-0000-000000000509', '00000000-0000-0000-0000-000000000309', NULL, 'Rabies', '2026-03-14 09:20:00+03', '2027-03-14 09:20:00+03', 'RAB-26-009', '00000000-0000-0000-0000-000000000209', 'Senior animal dose.'),
  ('00000000-0000-0000-0000-000000000510', '00000000-0000-0000-0000-000000000310', NULL, 'DHPP', '2026-03-21 15:40:00+03', '2026-06-21 15:40:00+03', 'DOG-26-010', '00000000-0000-0000-0000-000000000210', 'Puppy booster schedule.')
ON CONFLICT (vaccination_id) DO UPDATE SET
  animal_id = EXCLUDED.animal_id,
  vet_id = NULL,
  vaccine_type = EXCLUDED.vaccine_type,
  administered_at = EXCLUDED.administered_at,
  next_due_date = EXCLUDED.next_due_date,
  batch_no = EXCLUDED.batch_no,
  facility_id = EXCLUDED.facility_id,
  notes = EXCLUDED.notes;

INSERT INTO health_records (record_id, animal_id, vet_id, record_type, record_date, diagnosis, treatment, medication, facility_id, follow_up_date, cost_tl)
VALUES
  ('00000000-0000-0000-0000-000000000601', '00000000-0000-0000-0000-000000000301', NULL, 'Checkup', '2026-01-06 10:30:00+03', 'Healthy intake exam', 'Routine observation', NULL, '00000000-0000-0000-0000-000000000201', '2026-04-06 10:30:00+03', 450.00),
  ('00000000-0000-0000-0000-000000000602', '00000000-0000-0000-0000-000000000302', NULL, 'Checkup', '2026-01-10 11:30:00+03', 'Mild dental tartar', 'Dental cleaning advised', NULL, '00000000-0000-0000-0000-000000000202', '2026-07-10 11:30:00+03', 380.00),
  ('00000000-0000-0000-0000-000000000603', '00000000-0000-0000-0000-000000000303', NULL, 'Medication', '2026-01-19 13:00:00+03', 'Skin irritation', 'Topical wash', 'Chlorhexidine wash', '00000000-0000-0000-0000-000000000203', '2026-02-02 13:00:00+03', 520.00),
  ('00000000-0000-0000-0000-000000000604', '00000000-0000-0000-0000-000000000304', NULL, 'Surgery', '2026-01-30 09:00:00+03', 'Sterilization candidate', 'Neuter surgery completed', 'Post-op analgesic', '00000000-0000-0000-0000-000000000204', '2026-02-06 09:00:00+03', 1250.00),
  ('00000000-0000-0000-0000-000000000605', '00000000-0000-0000-0000-000000000305', NULL, 'Diagnosis', '2026-02-10 11:00:00+03', 'Underweight kitten', 'High calorie diet', 'Vitamin paste', '00000000-0000-0000-0000-000000000205', '2026-02-24 11:00:00+03', 300.00),
  ('00000000-0000-0000-0000-000000000606', '00000000-0000-0000-0000-000000000306', NULL, 'Surgery', '2026-02-12 08:30:00+03', 'Sterilization candidate', 'Spay surgery completed', 'Antibiotic course', '00000000-0000-0000-0000-000000000206', '2026-02-19 08:30:00+03', 1350.00),
  ('00000000-0000-0000-0000-000000000607', '00000000-0000-0000-0000-000000000307', NULL, 'Medication', '2026-03-02 12:00:00+03', 'Upper respiratory infection', 'Nebulization and rest', 'Doxycycline', '00000000-0000-0000-0000-000000000207', '2026-03-09 12:00:00+03', 640.00),
  ('00000000-0000-0000-0000-000000000608', '00000000-0000-0000-0000-000000000308', NULL, 'ChronicNote', '2026-03-08 14:00:00+03', 'Behavioral stress response', 'Low stimulus holding plan', NULL, '00000000-0000-0000-0000-000000000208', '2026-04-08 14:00:00+03', 250.00),
  ('00000000-0000-0000-0000-000000000609', '00000000-0000-0000-0000-000000000309', NULL, 'Checkup', '2026-03-14 10:00:00+03', 'Senior mobility stiffness', 'Joint supplement plan', 'Glucosamine', '00000000-0000-0000-0000-000000000209', '2026-06-14 10:00:00+03', 410.00),
  ('00000000-0000-0000-0000-000000000610', '00000000-0000-0000-0000-000000000310', NULL, 'Checkup', '2026-03-21 16:15:00+03', 'Healthy juvenile exam', 'Routine observation', NULL, '00000000-0000-0000-0000-000000000210', '2026-05-21 16:15:00+03', 350.00)
ON CONFLICT (record_id) DO UPDATE SET
  animal_id = EXCLUDED.animal_id,
  vet_id = NULL,
  record_type = EXCLUDED.record_type,
  record_date = EXCLUDED.record_date,
  diagnosis = EXCLUDED.diagnosis,
  treatment = EXCLUDED.treatment,
  medication = EXCLUDED.medication,
  facility_id = EXCLUDED.facility_id,
  follow_up_date = EXCLUDED.follow_up_date,
  cost_tl = EXCLUDED.cost_tl;

INSERT INTO operations (operation_id, animal_id, operation_type, operation_date, responsible_mun, staff_user_id, facility_id, result, cost_tl, notes, location_lat, location_lng)
VALUES
  ('00000000-0000-0000-0000-000000000701', '00000000-0000-0000-0000-000000000301', 'Microchipping', '2026-01-05 10:00:00+03', '00000000-0000-0000-0000-000000000101', NULL, '00000000-0000-0000-0000-000000000201', 'Completed', 180.00, 'Microchip verified at intake.', 41.0433, 29.0094),
  ('00000000-0000-0000-0000-000000000702', '00000000-0000-0000-0000-000000000302', 'Treatment', '2026-01-10 12:00:00+03', '00000000-0000-0000-0000-000000000102', NULL, '00000000-0000-0000-0000-000000000202', 'Completed', 380.00, 'Pre-adoption health review.', 40.9901, 29.0288),
  ('00000000-0000-0000-0000-000000000703', '00000000-0000-0000-0000-000000000303', 'Treatment', '2026-01-19 13:30:00+03', '00000000-0000-0000-0000-000000000103', NULL, '00000000-0000-0000-0000-000000000203', 'InProgress', 520.00, 'Skin treatment started.', 39.8909, 32.8425),
  ('00000000-0000-0000-0000-000000000704', '00000000-0000-0000-0000-000000000304', 'CNVR', '2026-01-30 09:30:00+03', '00000000-0000-0000-0000-000000000104', NULL, '00000000-0000-0000-0000-000000000204', 'Completed', 1250.00, 'Neuter, vaccinate, release.', 38.4189, 27.1287),
  ('00000000-0000-0000-0000-000000000705', '00000000-0000-0000-0000-000000000305', 'Treatment', '2026-02-10 11:30:00+03', '00000000-0000-0000-0000-000000000105', NULL, '00000000-0000-0000-0000-000000000205', 'InProgress', 300.00, 'Nutrition plan opened.', 36.8841, 30.7056),
  ('00000000-0000-0000-0000-000000000706', '00000000-0000-0000-0000-000000000306', 'CNVR', '2026-02-12 09:00:00+03', '00000000-0000-0000-0000-000000000106', NULL, '00000000-0000-0000-0000-000000000206', 'Completed', 1350.00, 'Spay, vaccinate, release.', 40.2136, 28.9844),
  ('00000000-0000-0000-0000-000000000707', '00000000-0000-0000-0000-000000000307', 'Relocation', '2026-03-01 16:00:00+03', '00000000-0000-0000-0000-000000000107', NULL, '00000000-0000-0000-0000-000000000207', 'Completed', 220.00, 'Moved for quarantine capacity.', 39.7667, 30.5256),
  ('00000000-0000-0000-0000-000000000708', '00000000-0000-0000-0000-000000000308', 'Relocation', '2026-03-07 09:30:00+03', '00000000-0000-0000-0000-000000000108', NULL, '00000000-0000-0000-0000-000000000208', 'Completed', 260.00, 'Moved away from school area.', 41.2867, 36.3300),
  ('00000000-0000-0000-0000-000000000709', '00000000-0000-0000-0000-000000000309', 'Treatment', '2026-03-14 10:30:00+03', '00000000-0000-0000-0000-000000000109', NULL, '00000000-0000-0000-0000-000000000209', 'Completed', 410.00, 'Senior mobility treatment.', 41.0027, 39.7168),
  ('00000000-0000-0000-0000-000000000710', '00000000-0000-0000-0000-000000000310', 'Microchipping', '2026-03-21 16:45:00+03', '00000000-0000-0000-0000-000000000110', NULL, '00000000-0000-0000-0000-000000000210', 'Completed', 180.00, 'Juvenile intake microchip.', 37.0662, 37.3833)
ON CONFLICT (operation_id) DO UPDATE SET
  animal_id = EXCLUDED.animal_id,
  operation_type = EXCLUDED.operation_type,
  operation_date = EXCLUDED.operation_date,
  responsible_mun = EXCLUDED.responsible_mun,
  staff_user_id = NULL,
  facility_id = EXCLUDED.facility_id,
  result = EXCLUDED.result,
  cost_tl = EXCLUDED.cost_tl,
  notes = EXCLUDED.notes,
  location_lat = EXCLUDED.location_lat,
  location_lng = EXCLUDED.location_lng;

INSERT INTO complaints (complaint_id, citizen_id, animal_id, incident_type, description, location_lat, location_lng, priority_level, status, responsible_mun, assigned_staff_id, submitted_at, resolved_at, photo_url, linked_operation, resolution_notes)
VALUES
  ('00000000-0000-0000-0000-000000000801', NULL, '00000000-0000-0000-0000-000000000301', 'SickInjured', 'Dog limping near ferry area.', 41.0433, 29.0094, 'High', 'Resolved', '00000000-0000-0000-0000-000000000101', NULL, '2026-01-05 08:40:00+03', '2026-01-05 12:00:00+03', NULL, '00000000-0000-0000-0000-000000000701', 'Animal collected and checked at shelter.'),
  ('00000000-0000-0000-0000-000000000802', NULL, '00000000-0000-0000-0000-000000000302', 'Other', 'Friendly cat repeatedly entering apartment lobby.', 40.9901, 29.0288, 'Low', 'Closed', '00000000-0000-0000-0000-000000000102', NULL, '2026-01-09 18:20:00+03', '2026-01-12 15:30:00+03', NULL, '00000000-0000-0000-0000-000000000702', 'Adoption applicant matched.'),
  ('00000000-0000-0000-0000-000000000803', NULL, '00000000-0000-0000-0000-000000000303', 'SickInjured', 'Skin wounds reported by resident.', 39.8909, 32.8425, 'Medium', 'InProgress', '00000000-0000-0000-0000-000000000103', NULL, '2026-01-18 09:00:00+03', NULL, NULL, '00000000-0000-0000-0000-000000000703', 'Treatment started.'),
  ('00000000-0000-0000-0000-000000000804', NULL, '00000000-0000-0000-0000-000000000304', 'Nuisance', 'Dog pack noise at night.', 38.4189, 27.1287, 'Medium', 'Resolved', '00000000-0000-0000-0000-000000000104', NULL, '2026-01-28 22:15:00+03', '2026-02-02 11:00:00+03', NULL, '00000000-0000-0000-0000-000000000704', 'CNVR completed and release area monitored.'),
  ('00000000-0000-0000-0000-000000000805', NULL, '00000000-0000-0000-0000-000000000305', 'SickInjured', 'Small kitten appears underweight.', 36.8841, 30.7056, 'High', 'InProgress', '00000000-0000-0000-0000-000000000105', NULL, '2026-02-09 07:30:00+03', NULL, NULL, '00000000-0000-0000-0000-000000000705', 'Nutrition care in progress.'),
  ('00000000-0000-0000-0000-000000000806', NULL, '00000000-0000-0000-0000-000000000306', 'Other', 'Female dog requested for sterilization program.', 40.2136, 28.9844, 'Medium', 'Resolved', '00000000-0000-0000-0000-000000000106', NULL, '2026-02-11 09:20:00+03', '2026-02-14 13:30:00+03', NULL, '00000000-0000-0000-0000-000000000706', 'Released after recovery check.'),
  ('00000000-0000-0000-0000-000000000807', NULL, '00000000-0000-0000-0000-000000000307', 'SickInjured', 'Cat sneezing in shared courtyard.', 39.7667, 30.5256, 'Medium', 'InProgress', '00000000-0000-0000-0000-000000000107', NULL, '2026-03-01 10:10:00+03', NULL, NULL, '00000000-0000-0000-0000-000000000707', 'Transferred for quarantine observation.'),
  ('00000000-0000-0000-0000-000000000808', NULL, '00000000-0000-0000-0000-000000000308', 'AggressiveBehavior', 'Dog guarding school entrance.', 41.2867, 36.3300, 'Critical', 'Resolved', '00000000-0000-0000-0000-000000000108', NULL, '2026-03-07 08:00:00+03', '2026-03-07 11:30:00+03', NULL, '00000000-0000-0000-0000-000000000708', 'Relocated and behavior note added.'),
  ('00000000-0000-0000-0000-000000000809', NULL, '00000000-0000-0000-0000-000000000309', 'SickInjured', 'Older cat moving slowly near mosque garden.', 41.0027, 39.7168, 'Medium', 'Closed', '00000000-0000-0000-0000-000000000109', NULL, '2026-03-13 10:45:00+03', '2026-03-14 12:00:00+03', NULL, '00000000-0000-0000-0000-000000000709', 'Exam completed and supplement plan opened.'),
  ('00000000-0000-0000-0000-000000000810', NULL, '00000000-0000-0000-0000-000000000310', 'Other', 'Puppy found near market stalls.', 37.0662, 37.3833, 'High', 'Resolved', '00000000-0000-0000-0000-000000000110', NULL, '2026-03-20 13:30:00+03', '2026-03-21 17:20:00+03', NULL, '00000000-0000-0000-0000-000000000710', 'Animal admitted and microchipped.')
ON CONFLICT (complaint_id) DO UPDATE SET
  citizen_id = NULL,
  animal_id = EXCLUDED.animal_id,
  incident_type = EXCLUDED.incident_type,
  description = EXCLUDED.description,
  location_lat = EXCLUDED.location_lat,
  location_lng = EXCLUDED.location_lng,
  priority_level = EXCLUDED.priority_level,
  status = EXCLUDED.status,
  responsible_mun = EXCLUDED.responsible_mun,
  assigned_staff_id = NULL,
  submitted_at = EXCLUDED.submitted_at,
  resolved_at = EXCLUDED.resolved_at,
  photo_url = NULL,
  linked_operation = EXCLUDED.linked_operation,
  resolution_notes = EXCLUDED.resolution_notes;

INSERT INTO adoptions (adoption_id, animal_id, adopter_id, staff_id, application_date, approval_date, status, compatibility_score, rejection_reason, next_checkin_date)
VALUES
  ('00000000-0000-0000-0000-000000000901', '00000000-0000-0000-0000-000000000302', NULL, NULL, '2026-01-11 10:00:00+03', '2026-01-12 14:00:00+03', 'Completed', 91.50, NULL, '2026-07-12 14:00:00+03'),
  ('00000000-0000-0000-0000-000000000902', '00000000-0000-0000-0000-000000000301', NULL, NULL, '2026-02-03 13:15:00+03', NULL, 'Pending', 82.00, NULL, '2026-05-03 13:15:00+03'),
  ('00000000-0000-0000-0000-000000000903', '00000000-0000-0000-0000-000000000303', NULL, NULL, '2026-02-08 16:40:00+03', NULL, 'Rejected', 48.25, 'Applicant housing did not match exercise needs.', NULL),
  ('00000000-0000-0000-0000-000000000904', '00000000-0000-0000-0000-000000000304', NULL, NULL, '2026-02-16 09:25:00+03', '2026-02-20 10:00:00+03', 'Approved', 88.75, NULL, '2026-05-20 10:00:00+03'),
  ('00000000-0000-0000-0000-000000000905', '00000000-0000-0000-0000-000000000305', NULL, NULL, '2026-02-22 12:10:00+03', NULL, 'Pending', 76.00, NULL, '2026-05-22 12:10:00+03'),
  ('00000000-0000-0000-0000-000000000906', '00000000-0000-0000-0000-000000000306', NULL, NULL, '2026-03-01 11:30:00+03', NULL, 'Returned', 69.50, NULL, '2026-06-01 11:30:00+03'),
  ('00000000-0000-0000-0000-000000000907', '00000000-0000-0000-0000-000000000307', NULL, NULL, '2026-03-05 15:20:00+03', NULL, 'Pending', 84.10, NULL, '2026-06-05 15:20:00+03'),
  ('00000000-0000-0000-0000-000000000908', '00000000-0000-0000-0000-000000000308', NULL, NULL, '2026-03-10 18:00:00+03', NULL, 'Rejected', 42.00, 'Experienced handler required.', NULL),
  ('00000000-0000-0000-0000-000000000909', '00000000-0000-0000-0000-000000000309', NULL, NULL, '2026-03-16 10:50:00+03', '2026-03-18 14:30:00+03', 'Approved', 89.20, NULL, '2026-06-18 14:30:00+03'),
  ('00000000-0000-0000-0000-000000000910', '00000000-0000-0000-0000-000000000310', NULL, NULL, '2026-03-24 09:15:00+03', NULL, 'Pending', 93.00, NULL, '2026-06-24 09:15:00+03')
ON CONFLICT (adoption_id) DO UPDATE SET
  animal_id = EXCLUDED.animal_id,
  adopter_id = NULL,
  staff_id = NULL,
  application_date = EXCLUDED.application_date,
  approval_date = EXCLUDED.approval_date,
  status = EXCLUDED.status,
  compatibility_score = EXCLUDED.compatibility_score,
  rejection_reason = EXCLUDED.rejection_reason,
  next_checkin_date = EXCLUDED.next_checkin_date;
