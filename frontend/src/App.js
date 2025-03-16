import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';

// Layout components
import MainLayout from './components/layouts/MainLayout';

// Pages
import Dashboard from './pages/Dashboard';
import Facilities from './pages/Facilities';
import FacilityDetails from './pages/FacilityDetails';
import Departments from './pages/Departments';
import DepartmentDetails from './pages/DepartmentDetails';
import Doctors from './pages/Doctors';
import DoctorDetails from './pages/DoctorDetails';
import Patients from './pages/Patients';
import PatientDetails from './pages/PatientDetails';
import Appointments from './pages/Appointments';
import MedicalRecords from './pages/MedicalRecords';
import DistributedSystemMap from './pages/DistributedSystemMap';
import NotFound from './pages/NotFound';

// Create theme
const theme = createTheme({
  palette: {
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
    background: {
      default: '#f5f5f5',
    },
  },
  typography: {
    fontFamily: [
      'Roboto',
      'Arial',
      'sans-serif',
    ].join(','),
  },
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <MainLayout>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/facilities" element={<Facilities />} />
            <Route path="/facilities/:id" element={<FacilityDetails />} />
            <Route path="/departments" element={<Departments />} />
            <Route path="/departments/:id" element={<DepartmentDetails />} />
            <Route path="/doctors" element={<Doctors />} />
            <Route path="/doctors/:id" element={<DoctorDetails />} />
            <Route path="/patients" element={<Patients />} />
            <Route path="/patients/:id" element={<PatientDetails />} />
            <Route path="/appointments" element={<Appointments />} />
            <Route path="/medical-records" element={<MedicalRecords />} />
            <Route path="/distributed-system" element={<DistributedSystemMap />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </MainLayout>
      </Router>
    </ThemeProvider>
  );
}

export default App; 