import React, { useState, useEffect } from 'react';
import { 
  Box, Typography, Paper, Divider, Card, CardContent, 
  Grid, Button, Chip, CircularProgress, IconButton,
  Tooltip, LinearProgress, Link 
} from '@mui/material';
import {
  Storage as DatabaseIcon,
  Language as NetworkIcon,
  Sync as SyncIcon,
  CloudQueue as CloudIcon,
  Security as SecurityIcon,
  Error as ErrorIcon,
  CheckCircle as SuccessIcon,
  Info as InfoIcon,
  Analytics as AnalyticsIcon
} from '@mui/icons-material';
import { getFacilities } from '../services/api';

// Simulated database distribution and replication status
const getSimulatedDatabaseStatus = (facilities) => {
  if (!facilities || !facilities.length) return [];
  
  return facilities.map(facility => {
    // Generate random status for simulation
    const isOnline = Math.random() > 0.1; // 90% chance of being online
    const syncStatus = isOnline ? (Math.random() > 0.2 ? 'synchronized' : 'syncing') : 'offline';
    const replicationLag = isOnline ? Math.floor(Math.random() * 60) : null; // 0-60 seconds lag
    
    return {
      facilityId: facility.facility_id,
      facilityName: facility.facility_name,
      location: facility.location,
      dbInstanceName: `${facility.facility_name.replace(/\s+/g, '_').toLowerCase()}_db`,
      isOnline,
      syncStatus,
      replicationLag,
      lastSync: isOnline ? new Date(Date.now() - Math.floor(Math.random() * 3600000)).toISOString() : null,
      recordsCount: isOnline ? Math.floor(Math.random() * 50000) + 10000 : null,
      dbSize: isOnline ? (Math.random() * 10 + 2).toFixed(2) : null // in GB
    };
  });
};

// Simulated network metrics
const getSimulatedNetworkMetrics = (facilities) => {
  if (!facilities || !facilities.length) return [];
  
  const mainFacility = facilities[0]; // Assuming first facility is the main one
  
  return facilities.slice(1).map(facility => {
    const latency = Math.floor(Math.random() * 100) + 5; // 5-105ms
    const packetLoss = Math.random() * 1; // 0-1%
    const bandwidth = Math.floor(Math.random() * 900) + 100; // 100-1000 Mbps
    
    return {
      fromFacility: mainFacility.facility_name,
      toFacility: facility.facility_name,
      latency,
      packetLoss,
      bandwidth,
      status: latency < 80 && packetLoss < 0.5 ? 'good' : 'degraded'
    };
  });
};

const DistributedSystemMap = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [facilities, setFacilities] = useState([]);
  const [dbStatus, setDbStatus] = useState([]);
  const [networkMetrics, setNetworkMetrics] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const facilitiesData = await getFacilities();
        setFacilities(facilitiesData);
        
        // Get simulated distributed database status
        const dbStatusData = getSimulatedDatabaseStatus(facilitiesData);
        setDbStatus(dbStatusData);
        
        // Get simulated network metrics
        const networkData = getSimulatedNetworkMetrics(facilitiesData);
        setNetworkMetrics(networkData);
        
      } catch (err) {
        console.error('Error fetching distributed system data:', err);
        setError('Failed to load system architecture data. Please try again later.');
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const refreshData = () => {
    if (facilities.length) {
      const dbStatusData = getSimulatedDatabaseStatus(facilities);
      setDbStatus(dbStatusData);
      
      const networkData = getSimulatedNetworkMetrics(facilities);
      setNetworkMetrics(networkData);
    }
  };

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

  // Determine overall system health 
  const offlineCount = dbStatus.filter(db => !db.isOnline).length;
  const syncingCount = dbStatus.filter(db => db.syncStatus === 'syncing').length;
  const networkIssuesCount = networkMetrics.filter(metric => metric.status !== 'good').length;
  
  const systemHealth = offlineCount === 0 && syncingCount === 0 && networkIssuesCount === 0
    ? 'healthy'
    : offlineCount > 0 
      ? 'critical'
      : 'warning';

  return (
    <Box sx={{ flexGrow: 1, py: 2 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Box>
          <Typography variant="h4" gutterBottom>
            Distributed System Architecture
          </Typography>
          <Typography variant="subtitle1" gutterBottom color="text.secondary">
            Vietnam National Hospital Distributed Database Management System
          </Typography>
        </Box>
        <Button 
          variant="contained" 
          startIcon={<SyncIcon />}
          onClick={refreshData}
        >
          Refresh Status
        </Button>
      </Box>

      {/* Overall System Health Card */}
      <Card sx={{ mb: 4, bgcolor: 
          systemHealth === 'healthy' ? '#e8f5e9' :
          systemHealth === 'warning' ? '#fff8e1' : '#ffebee'
      }}>
        <CardContent>
          <Box sx={{ display: 'flex', alignItems: 'center' }}>
            {systemHealth === 'healthy' && <SuccessIcon fontSize="large" sx={{ color: '#2e7d32', mr: 2 }} />}
            {systemHealth === 'warning' && <InfoIcon fontSize="large" sx={{ color: '#f57c00', mr: 2 }} />}
            {systemHealth === 'critical' && <ErrorIcon fontSize="large" sx={{ color: '#c62828', mr: 2 }} />}
            
            <Box>
              <Typography variant="h5">
                System Health: {systemHealth === 'healthy' ? 'Healthy' : systemHealth === 'warning' ? 'Warning' : 'Critical Issues'}
              </Typography>
              <Typography variant="body1">
                {dbStatus.length} database nodes | {offlineCount} offline | {syncingCount} syncing | {networkIssuesCount} network issues
              </Typography>
            </Box>
          </Box>
        </CardContent>
      </Card>

      {/* Database Nodes Section */}
      <Paper sx={{ p: 3, mb: 4 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
          <DatabaseIcon sx={{ mr: 1 }} color="primary" />
          <Typography variant="h5">
            Database Nodes and Replication Status
          </Typography>
        </Box>
        <Divider sx={{ mb: 3 }} />
        
        <Grid container spacing={3}>
          {dbStatus.map(db => (
            <Grid item xs={12} md={6} lg={4} key={db.facilityId}>
              <Card 
                elevation={3} 
                sx={{ 
                  height: '100%',
                  bgcolor: !db.isOnline ? '#ffebee' : 
                           db.syncStatus === 'synchronized' ? '#e8f5e9' : 
                           '#fff8e1'
                }}
              >
                <CardContent>
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
                    <Typography variant="h6" component="div">
                      {db.facilityName}
                    </Typography>
                    <Chip 
                      size="small"
                      label={db.isOnline ? 'Online' : 'Offline'}
                      color={db.isOnline ? 'success' : 'error'}
                    />
                  </Box>
                  
                  <Typography variant="body2" color="text.secondary" gutterBottom>
                    Instance: {db.dbInstanceName}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" gutterBottom>
                    Location: {db.location}
                  </Typography>
                  
                  {db.isOnline && (
                    <>
                      <Box sx={{ display: 'flex', alignItems: 'center', mt: 2 }}>
                        <Typography variant="body2" component="div" sx={{ width: '40%' }}>
                          Sync Status:
                        </Typography>
                        <Chip 
                          size="small"
                          label={db.syncStatus === 'synchronized' ? 'Synchronized' : 'Syncing'}
                          color={db.syncStatus === 'synchronized' ? 'success' : 'warning'}
                          icon={db.syncStatus === 'synchronized' ? <SuccessIcon /> : <SyncIcon />}
                        />
                      </Box>
                      
                      <Box sx={{ display: 'flex', alignItems: 'center', mt: 1 }}>
                        <Typography variant="body2" component="div" sx={{ width: '40%' }}>
                          Replication Lag:
                        </Typography>
                        <Typography variant="body2" component="div">
                          {db.replicationLag} seconds
                        </Typography>
                      </Box>
                      
                      <Box sx={{ display: 'flex', alignItems: 'center', mt: 1 }}>
                        <Typography variant="body2" component="div" sx={{ width: '40%' }}>
                          Last Sync:
                        </Typography>
                        <Typography variant="body2" component="div">
                          {new Date(db.lastSync).toLocaleString()}
                        </Typography>
                      </Box>
                      
                      <Box sx={{ display: 'flex', alignItems: 'center', mt: 1 }}>
                        <Typography variant="body2" component="div" sx={{ width: '40%' }}>
                          Records:
                        </Typography>
                        <Typography variant="body2" component="div">
                          {db.recordsCount.toLocaleString()}
                        </Typography>
                      </Box>
                      
                      <Box sx={{ display: 'flex', alignItems: 'center', mt: 1 }}>
                        <Typography variant="body2" component="div" sx={{ width: '40%' }}>
                          Database Size:
                        </Typography>
                        <Typography variant="body2" component="div">
                          {db.dbSize} GB
                        </Typography>
                      </Box>
                    </>
                  )}
                  
                  {!db.isOnline && (
                    <Box sx={{ mt: 2 }}>
                      <Typography variant="body2" color="error">
                        This database node is currently offline. Check network connectivity and server status.
                      </Typography>
                    </Box>
                  )}
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Paper>

      {/* Network Connectivity Section */}
      <Paper sx={{ p: 3, mb: 4 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
          <NetworkIcon sx={{ mr: 1 }} color="primary" />
          <Typography variant="h5">
            Network Connectivity
          </Typography>
        </Box>
        <Divider sx={{ mb: 3 }} />
        
        {networkMetrics.length === 0 ? (
          <Typography variant="body1">No network metrics available.</Typography>
        ) : (
          <Grid container spacing={3}>
            {networkMetrics.map((metric, index) => (
              <Grid item xs={12} md={6} key={index}>
                <Card 
                  elevation={3}
                  sx={{ 
                    bgcolor: metric.status === 'good' ? '#e8f5e9' : '#fff8e1',
                  }}
                >
                  <CardContent>
                    <Typography variant="h6" gutterBottom>
                      {metric.fromFacility} ↔ {metric.toFacility}
                    </Typography>
                    
                    <Box sx={{ mt: 2 }}>
                      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 1 }}>
                        <Typography variant="body2">Latency:</Typography>
                        <Typography variant="body2">{metric.latency} ms</Typography>
                      </Box>
                      <LinearProgress 
                        variant="determinate" 
                        value={Math.min((metric.latency / 100) * 100, 100)} 
                        sx={{ 
                          mb: 2, 
                          height: 10, 
                          borderRadius: 5,
                          bgcolor: '#e0e0e0',
                          '& .MuiLinearProgress-bar': {
                            bgcolor: metric.latency < 50 ? '#4caf50' : 
                                    metric.latency < 80 ? '#ff9800' : '#f44336'
                          }
                        }}
                      />
                      
                      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 1 }}>
                        <Typography variant="body2">Packet Loss:</Typography>
                        <Typography variant="body2">{metric.packetLoss.toFixed(2)}%</Typography>
                      </Box>
                      <LinearProgress 
                        variant="determinate" 
                        value={Math.min(metric.packetLoss * 100, 100)} 
                        sx={{ 
                          mb: 2, 
                          height: 10, 
                          borderRadius: 5,
                          bgcolor: '#e0e0e0',
                          '& .MuiLinearProgress-bar': {
                            bgcolor: metric.packetLoss < 0.2 ? '#4caf50' : 
                                    metric.packetLoss < 0.5 ? '#ff9800' : '#f44336'
                          }
                        }}
                      />
                      
                      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 1 }}>
                        <Typography variant="body2">Bandwidth:</Typography>
                        <Typography variant="body2">{metric.bandwidth} Mbps</Typography>
                      </Box>
                      <LinearProgress 
                        variant="determinate" 
                        value={Math.min((metric.bandwidth / 1000) * 100, 100)} 
                        sx={{ 
                          height: 10, 
                          borderRadius: 5,
                          bgcolor: '#e0e0e0',
                          '& .MuiLinearProgress-bar': {
                            bgcolor: '#4caf50'
                          }
                        }}
                      />
                    </Box>
                    
                    <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 2 }}>
                      <Chip 
                        size="small"
                        label={metric.status === 'good' ? 'Good Connection' : 'Degraded Performance'}
                        color={metric.status === 'good' ? 'success' : 'warning'}
                      />
                    </Box>
                  </CardContent>
                </Card>
              </Grid>
            ))}
          </Grid>
        )}
      </Paper>

      {/* System Architecture Diagram */}
      <Paper sx={{ p: 3, mb: 4 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
          <CloudIcon sx={{ mr: 1 }} color="primary" />
          <Typography variant="h5">
            Distributed System Architecture
          </Typography>
        </Box>
        <Divider sx={{ mb: 3 }} />
        
        <Box sx={{ p: 2, textAlign: 'center' }}>
          <Typography variant="body1" sx={{ mb: 3 }}>
            The Vietnam National Hospital operates on a distributed database architecture with primary nodes at each facility, 
            synchronized with the central database. Data replication ensures high availability and disaster recovery capabilities.
          </Typography>
          
          <Box sx={{ 
            border: '1px solid #e0e0e0', 
            borderRadius: 2, 
            p: 3, 
            backgroundColor: '#f5f5f5',
            maxWidth: '800px',
            margin: '0 auto',
            position: 'relative',
            minHeight: '400px'
          }}>
            {/* This is a placeholder for a real architecture diagram */}
            <Box sx={{ 
              position: 'absolute',
              top: '50%',
              left: '50%',
              transform: 'translate(-50%, -50%)',
              width: '150px',
              height: '150px',
              borderRadius: '50%',
              bgcolor: '#1976d2',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              flexDirection: 'column',
              color: 'white',
              border: '3px solid #fff',
              boxShadow: 3
            }}>
              <DatabaseIcon fontSize="large" />
              <Typography variant="subtitle1">Central DB</Typography>
            </Box>
            
            {/* Facility nodes positioned around central DB */}
            {dbStatus.map((db, index) => {
              const angle = (360 / dbStatus.length) * index * (Math.PI / 180);
              const radius = 150;
              const x = radius * Math.cos(angle);
              const y = radius * Math.sin(angle);
              
              return (
                <Box 
                  key={db.facilityId}
                  sx={{
                    position: 'absolute',
                    top: '50%',
                    left: '50%',
                    transform: `translate(calc(-50% + ${x}px), calc(-50% + ${y}px))`,
                    width: '120px',
                    height: '120px',
                    borderRadius: '50%',
                    bgcolor: db.isOnline ? '#4caf50' : '#f44336',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    flexDirection: 'column',
                    color: 'white',
                    border: '3px solid #fff',
                    boxShadow: 2,
                    transition: 'all 0.3s ease'
                  }}
                >
                  <DatabaseIcon />
                  <Typography variant="caption" sx={{ textAlign: 'center', padding: '0 5px' }}>
                    {db.facilityName}
                  </Typography>
                </Box>
              );
            })}
            
            {/* Connection lines */}
            <svg 
              style={{ 
                position: 'absolute', 
                top: 0, 
                left: 0, 
                width: '100%', 
                height: '100%',
                zIndex: 0
              }}
            >
              {dbStatus.map((db, index) => {
                const angle = (360 / dbStatus.length) * index * (Math.PI / 180);
                const radius = 150;
                const x = radius * Math.cos(angle);
                const y = radius * Math.sin(angle);
                
                return (
                  <line 
                    key={db.facilityId}
                    x1="50%"
                    y1="50%"
                    x2={`calc(50% + ${x}px)`}
                    y2={`calc(50% + ${y}px)`}
                    style={{ 
                      stroke: db.isOnline ? 
                        (db.syncStatus === 'synchronized' ? '#4caf50' : '#ff9800') : 
                        '#f44336',
                      strokeWidth: 2,
                      strokeDasharray: db.syncStatus === 'syncing' ? '5,5' : 'none'
                    }}
                  />
                );
              })}
            </svg>
          </Box>
        </Box>
      </Paper>

      {/* System Information */}
      <Paper sx={{ p: 3 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
          <AnalyticsIcon sx={{ mr: 1 }} color="primary" />
          <Typography variant="h5">
            System Information
          </Typography>
        </Box>
        <Divider sx={{ mb: 3 }} />
        
        <Grid container spacing={4}>
          <Grid item xs={12} md={6}>
            <Typography variant="h6" gutterBottom>
              Replication Technology
            </Typography>
            <Typography variant="body2" paragraph>
              Our distributed database system uses Oracle's Advanced Replication technology, enabling 
              multi-master replication across all facilities. This provides high availability and 
              fault tolerance for the hospital's critical data.
            </Typography>
            
            <Typography variant="h6" gutterBottom>
              Data Synchronization
            </Typography>
            <Typography variant="body2" paragraph>
              Synchronization occurs in near real-time with configurable intervals for different data 
              types. Critical patient data is synchronized immediately, while less critical data may 
              have scheduled synchronization windows.
            </Typography>
          </Grid>
          
          <Grid item xs={12} md={6}>
            <Typography variant="h6" gutterBottom>
              Disaster Recovery
            </Typography>
            <Typography variant="body2" paragraph>
              Our system architecture includes multiple redundancy layers and an automated failover 
              system. In case of node failure, traffic is automatically redirected to operational nodes, 
              ensuring continuous service availability.
            </Typography>
            
            <Typography variant="h6" gutterBottom>
              Security Measures
            </Typography>
            <Typography variant="body2" paragraph>
              All data is encrypted both at rest and in transit using industry-standard encryption 
              protocols. Access control is managed through centralized identity services with 
              role-based permissions and comprehensive audit logging.
            </Typography>
          </Grid>
        </Grid>
      </Paper>
    </Box>
  );
};

export default DistributedSystemMap; 