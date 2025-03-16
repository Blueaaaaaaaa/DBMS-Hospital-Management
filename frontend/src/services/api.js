import axios from 'axios';

// Create an axios instance with default config
const api = axios.create({
  baseURL: '/api',
  headers: {
    'Content-Type': 'application/json'
  }
});

// API functions for facilities
export const getFacilities = async () => {
  try {
    const response = await api.get('/facilities');
    return response.data;
  } catch (error) {
    console.error('Error fetching facilities:', error);
    throw error;
  }
};

export const getFacilityById = async (id) => {
  try {
    const response = await api.get(`/facilities/${id}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching facility with id ${id}:`, error);
    throw error;
  }
};

export const getFacilityDepartments = async (id) => {
  try {
    const response = await api.get(`/facilities/${id}/departments`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching departments for facility with id ${id}:`, error);
    throw error;
  }
};

// API functions for departments
export const getDepartments = async () => {
  try {
    const response = await api.get('/departments');
    return response.data;
  } catch (error) {
    console.error('Error fetching departments:', error);
    throw error;
  }
};

export const getDepartmentById = async (id) => {
  try {
    const response = await api.get(`/departments/${id}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching department with id ${id}:`, error);
    throw error;
  }
};

export const getDepartmentDoctors = async (id) => {
  try {
    const response = await api.get(`/departments/${id}/doctors`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching doctors for department with id ${id}:`, error);
    throw error;
  }
};

export const getDepartmentStaff = async (id) => {
  try {
    const response = await api.get(`/departments/${id}/staff`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching staff for department with id ${id}:`, error);
    throw error;
  }
};

// API functions for doctors
export const getDoctors = async () => {
  try {
    const response = await api.get('/doctors');
    return response.data;
  } catch (error) {
    console.error('Error fetching doctors:', error);
    throw error;
  }
};

export const getDoctorById = async (id) => {
  try {
    const response = await api.get(`/doctors/${id}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching doctor with id ${id}:`, error);
    throw error;
  }
};

export const getDoctorAppointments = async (id) => {
  try {
    const response = await api.get(`/doctors/${id}/appointments`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching appointments for doctor with id ${id}:`, error);
    throw error;
  }
};

// API functions for patients
export const getPatients = async () => {
  try {
    const response = await api.get('/patients');
    return response.data;
  } catch (error) {
    console.error('Error fetching patients:', error);
    throw error;
  }
};

export const getPatientById = async (id) => {
  try {
    const response = await api.get(`/patients/${id}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching patient with id ${id}:`, error);
    throw error;
  }
};

export const getPatientRecords = async (id) => {
  try {
    const response = await api.get(`/patients/${id}/medical_records`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching medical records for patient with id ${id}:`, error);
    throw error;
  }
};

export const getPatientAppointments = async (id) => {
  try {
    const response = await api.get(`/patients/${id}/appointments`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching appointments for patient with id ${id}:`, error);
    throw error;
  }
};

// API functions for medical records
export const getMedicalRecords = async () => {
  try {
    const response = await api.get('/medical_records');
    return response.data;
  } catch (error) {
    console.error('Error fetching medical records:', error);
    throw error;
  }
};

export const getMedicalRecordById = async (id) => {
  try {
    const response = await api.get(`/medical_records/${id}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching medical record with id ${id}:`, error);
    throw error;
  }
};

// API functions for appointments
export const getAppointments = async () => {
  try {
    const response = await api.get('/appointments');
    return response.data;
  } catch (error) {
    console.error('Error fetching appointments:', error);
    throw error;
  }
};

export const getAppointmentById = async (id) => {
  try {
    const response = await api.get(`/appointments/${id}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching appointment with id ${id}:`, error);
    throw error;
  }
};

// API functions for dashboard statistics
export const getDepartmentStats = async () => {
  try {
    const response = await api.get('/stats/departments');
    return response.data;
  } catch (error) {
    console.error('Error fetching department statistics:', error);
    throw error;
  }
};

export const getAppointmentStats = async () => {
  try {
    const response = await api.get('/stats/appointments');
    return response.data;
  } catch (error) {
    console.error('Error fetching appointment statistics:', error);
    throw error;
  }
};

export const getPatientStats = async () => {
  try {
    const response = await api.get('/stats/patients');
    return response.data;
  } catch (error) {
    console.error('Error fetching patient statistics:', error);
    throw error;
  }
}; 