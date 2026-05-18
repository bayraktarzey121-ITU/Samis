import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    fallbackLng: 'tr',
    resources: {
      tr: {
        translation: {
          app_name: 'SAMIS',
          subtitle: 'Türkiye Hayvan Yönetimi',
          dashboard: 'Panel',
          animals: 'Hayvanlar',
          shelters: 'Barınaklar',
          complaints: 'Şikayetler',
          adoption: 'Sahiplendirme',
          reports: 'Raporlar',
          audit_log: 'Denetim İzi',
          new_registration: 'Yeni Kayıt',
          total_animals: 'Toplam Hayvan',
          adopted: 'Sahiplenilen',
          open_complaints: 'Açık Şikayetler',
          shelter_capacity: 'Barınak Kapasitesi',
          capacity_alert: 'KAPASİTE UYARISI',
          critical_alert: 'Kritik Uyarı',
          active_facilities: 'Aktif Tesisler',
          sterilization_rate: 'Kısırlaştırma Oranı',
        }
      },
      en: {
        translation: {
          app_name: 'SAMIS',
          subtitle: 'Stray Animal Management',
          dashboard: 'Dashboard',
          animals: 'Animals',
          shelters: 'Shelters',
          complaints: 'Complaints',
          adoption: 'Adoption',
          reports: 'Reports',
          audit_log: 'Audit Log',
          new_registration: 'New Registration',
          total_animals: 'Total Animals',
          adopted: 'Adopted',
          open_complaints: 'Open Complaints',
          shelter_capacity: 'Shelter Capacity',
          capacity_alert: 'CAPACITY ALERT',
          critical_alert: 'Critical Alert',
          active_facilities: 'Active Facilities',
          sterilization_rate: 'Sterilization Rate',
        }
      }
    }
  });

export default i18n;
