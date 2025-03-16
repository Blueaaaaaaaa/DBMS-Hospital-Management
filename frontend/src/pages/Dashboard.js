import React, { useState, useEffect } from 'react';
import { 
  Box, Grid, Paper, Typography, Card, CardContent, 
  CardHeader, Divider, Avatar, CircularProgress
} from '@mui/material';
import {
  LocalHospital as HospitalIcon,
  MeetingRoom as DepartmentIcon,
  PersonAdd as DoctorIcon,
  People as PatientIcon,
  Event as AppointmentIcon,
  Assignment as RecordIcon
} from '@mui/icons-material';
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, 
  Legend, ResponsiveContainer, PieChart, Pie, Cell
} from 'recharts';
import { 
  getDepartmentStats, 
  getAppointmentStats, 
  getPatientStats,
  getFacilities
} from '../services/api';

// Colors for charts
const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884d8', '#82ca9d'];

// Stat card component
const StatCard = ({ title, value, icon, color }) => (
  <Card sx={{ height: '100%' }}>
    <CardContent>
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
        <Avatar sx={{ bgcolor: color, mr: 2 }}>
          {icon}
        </Avatar>
        <Typography variant="h6" component="div">
          {title}
        </Typography>
      </Box>
      <Typography variant="h4" component="div" sx={{ textAlign: 'center', my: 2 }}>
        {value}
      </Typography>
    </CardContent>
  </Card>
);

const Dashboard = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [departmentStats, setDepartmentStats] = useState([]);
  const [appointmentStats, setAppointmentStats] = useState([]);
  const [patientStats, setPatientStats] = useState(null);
  const [facilities, setFacilities] = useState([]);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        setLoading(true);
        const [deptStats, apptStats, patStats, facData] = await Promise.all([
          getDepartmentStats(),
          getAppointmentStats(),
          getPatientStats(),
          getFacilities()
        ]);
        
        setDepartmentStats(deptStats);
        setAppointmentStats(apptStats);
        setPatientStats(patStats);
        setFacilities(facData);
      } catch (err) {
        console.error('Error fetching dashboard data:', err);
        setError('Failed to load dashboard data. Please try again later.');
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
  }, []);

  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Box sx={{ p: 3 }}>
        <Typography variant="h6" color="error">{error}</Typography>
      </Box>
    );
  }

  // Prepare data for department chart
  const departmentChartData = departmentStats.slice(0, 6).map(dept => ({
    name: dept.department_name,
    doctors: dept.doctors_count || 0,
    staff: dept.staff_count || 0
  }));

  // Prepare data for appointment status pie chart
  const appointmentPieData = appointmentStats.map(status => ({
    name: status.status,
    value: status.count
  }));

  // Prepare patient gender data
  const genderData = patientStats && patientStats.gender_distribution ? [
    { name: 'Nam', value: patientStats.gender_distribution.male },
    { name: 'Nữ', value: patientStats.gender_distribution.female }
  ] : [];

  return (
    <Box sx={{ flexGrow: 1, py: 2 }}>
      <Typography variant="h4" gutterBottom>
        Dashboard
      </Typography>
      <Typography variant="subtitle1" gutterBottom color="text.secondary">
        Vietnam National Hospital Management System Overview
      </Typography>
      
      {/* Quick Stats */}
      <Grid container spacing={3} sx={{ mt: 1, mb: 4 }}>
        <Grid item xs={12} sm={6} md={4} lg={2}>
          <StatCard
            title="Facilities"
            value={facilities.length}
            icon={<HospitalIcon />}
            color="#1976d2"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4} lg={2}>
          <StatCard
            title="Departments"
            value={departmentStats.length}
            icon={<DepartmentIcon />}
            color="#2196f3"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4} lg={2}>
          <StatCard
            title="Doctors"
            value={departmentStats.reduce((sum, dept) => sum + (dept.doctors_count || 0), 0)}
            icon={<DoctorIcon />}
            color="#00bcd4"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4} lg={2}>
          <StatCard
            title="Patients"
            value={patientStats ? patientStats.total : 0}
            icon={<PatientIcon />}
            color="#4caf50"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4} lg={2}>
          <StatCard
            title="Appointments"
            value={appointmentStats.reduce((sum, stat) => sum + stat.count, 0)}
            icon={<AppointmentIcon />}
            color="#ff9800"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4} lg={2}>
          <StatCard
            title="Records"
            value="--"
            icon={<RecordIcon />}
            color="#f44336"
          />
        </Grid>
      </Grid>

      {/* Charts */}
      <Grid container spacing={3}>
        {/* Department Staff Chart */}
        <Grid item xs={12} lg={8}>
          <Paper sx={{ p: 2, height: '100%' }}>
            <Typography variant="h6" gutterBottom>
              Staff Distribution by Department
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <ResponsiveContainer width="100%" height={300}>
              <BarChart
                data={departmentChartData}
                margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
              >
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="doctors" fill="#8884d8" name="Doctors" />
                <Bar dataKey="staff" fill="#82ca9d" name="Staff" />
              </BarChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>

        {/* Appointment Status Pie Chart */}
        <Grid item xs={12} md={6} lg={4}>
          <Paper sx={{ p: 2, height: '100%' }}>
            <Typography variant="h6" gutterBottom>
              Appointment Status
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={appointmentPieData}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="value"
                  label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                >
                  {appointmentPieData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>

        {/* Patient Gender Distribution */}
        <Grid item xs={12} md={6} lg={4}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Patient Gender Distribution
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={genderData}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="value"
                  label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                >
                  <Cell fill="#2196f3" /> {/* Male */}
                  <Cell fill="#f06292" /> {/* Female */}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>

        {/* Facilities List */}
        <Grid item xs={12} md={6} lg={8}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Hospital Facilities
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <Box sx={{ maxHeight: 300, overflow: 'auto' }}>
              {facilities.map((facility) => (
                <Card key={facility.facility_id} sx={{ mb: 2 }}>
                  <CardHeader
                    avatar={
                      <Avatar sx={{ bgcolor: '#1976d2' }}>
                        <HospitalIcon />
                      </Avatar>
                    }
                    title={facility.facility_name}
                    subheader={facility.location}
                  />
                  <CardContent>
                    <Typography variant="body2" color="text.secondary">
                      {facility.description}
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                      Contact: {facility.contact_info}
                    </Typography>
                  </CardContent>
                </Card>
              ))}
            </Box>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Dashboard; 