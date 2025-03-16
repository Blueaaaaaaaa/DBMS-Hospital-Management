from sqlalchemy import Column, Integer, String, Date, ForeignKey, Text, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

class Facility(Base):
    __tablename__ = 'FACILITIES'
    
    facility_id = Column('FACILITYID', Integer, primary_key=True)
    facility_name = Column('FACILITYNAME', String(100), nullable=False)
    location = Column('LOCATION', String(200), nullable=False)
    contact_info = Column('CONTACTINFO', String(100))
    manager_id = Column('MANAGERID', Integer, ForeignKey('STAFF.STAFFID'))
    description = Column('DESCRIPTION', String(500))
    
    # Relationships
    departments = relationship("Department", back_populates="facility")
    manager = relationship("Staff", foreign_keys=[manager_id])

class Department(Base):
    __tablename__ = 'DEPARTMENTS'
    
    department_id = Column('DEPARTMENTID', Integer, primary_key=True)
    department_name = Column('DEPARTMENTNAME', String(100), nullable=False)
    location = Column('LOCATION', String(200))
    head_doctor_id = Column('HEADDOCTORID', Integer, ForeignKey('DOCTORS.DOCTORID'))
    description = Column('DESCRIPTION', String(500))
    phone_number = Column('PHONENUMBER', String(25))
    facility_id = Column('FACILITYID', Integer, ForeignKey('FACILITIES.FACILITYID'))
    
    # Relationships
    facility = relationship("Facility", back_populates="departments")
    head_doctor = relationship("Doctor", foreign_keys=[head_doctor_id])
    doctors = relationship("Doctor", back_populates="department", foreign_keys="[Doctor.department_id]")
    staff = relationship("Staff", back_populates="department")
    appointments = relationship("Appointment", back_populates="department")

class Doctor(Base):
    __tablename__ = 'DOCTORS'
    
    doctor_id = Column('DOCTORID', Integer, primary_key=True)
    full_name = Column('FULLNAME', String(100), nullable=False)
    date_of_birth = Column('DATEOFBIRTH', Date)
    gender = Column('GENDER', String(10))
    specialization = Column('SPECIALIZATION', String(100))
    department_id = Column('DEPARTMENTID', Integer, ForeignKey('DEPARTMENTS.DEPARTMENTID'))
    license_number = Column('LICENSENUMBER', String(50), nullable=False)
    contact_info = Column('CONTACTINFO', String(100))
    email = Column('EMAIL', String(100))
    hire_date = Column('HIREDATE', Date)
    qualification = Column('QUALIFICATION', String(200))
    
    # Relationships
    department = relationship("Department", back_populates="doctors", foreign_keys=[department_id])
    medical_records = relationship("MedicalRecord", back_populates="doctor")
    appointments = relationship("Appointment", back_populates="doctor")
    prescriptions = relationship("Prescription", back_populates="doctor")

class Staff(Base):
    __tablename__ = 'STAFF'
    
    staff_id = Column('STAFFID', Integer, primary_key=True)
    full_name = Column('FULLNAME', String(100), nullable=False)
    date_of_birth = Column('DATEOFBIRTH', Date)
    gender = Column('GENDER', String(10))
    position = Column('POSITION', String(100))
    department_id = Column('DEPARTMENTID', Integer, ForeignKey('DEPARTMENTS.DEPARTMENTID'))
    contact_info = Column('CONTACTINFO', String(100))
    email = Column('EMAIL', String(100))
    hire_date = Column('HIREDATE', Date)
    
    # Relationships
    department = relationship("Department", back_populates="staff")
    managed_facilities = relationship("Facility", foreign_keys=[Facility.manager_id])

class Patient(Base):
    __tablename__ = 'PATIENTS'
    
    patient_id = Column('PATIENTID', Integer, primary_key=True)
    full_name = Column('FULLNAME', String(100), nullable=False)
    date_of_birth = Column('DATEOFBIRTH', Date)
    gender = Column('GENDER', String(10))
    address = Column('ADDRESS', String(200))
    phone = Column('PHONE', String(20))
    email = Column('EMAIL', String(100))
    insurance_id = Column('INSURANCEID', String(50))
    blood_type = Column('BLOODTYPE', String(10))
    emergency_contact = Column('EMERGENCYCONTACT', String(100))
    registration_date = Column('REGISTRATIONDATE', Date)
    
    # Relationships
    medical_records = relationship("MedicalRecord", back_populates="patient")
    appointments = relationship("Appointment", back_populates="patient")
    prescriptions = relationship("Prescription", back_populates="patient")

class MedicalRecord(Base):
    __tablename__ = 'MEDICALRECORDS'
    
    record_id = Column('RECORDID', Integer, primary_key=True)
    patient_id = Column('PATIENTID', Integer, ForeignKey('PATIENTS.PATIENTID'))
    doctor_id = Column('DOCTORID', Integer, ForeignKey('DOCTORS.DOCTORID'))
    date_created = Column('DATECREATED', Date)
    diagnosis = Column('DIAGNOSIS', String(500))
    treatment = Column('TREATMENT', String(500))
    notes = Column('NOTES', String(1000))
    
    # Relationships
    patient = relationship("Patient", back_populates="medical_records")
    doctor = relationship("Doctor", back_populates="medical_records")
    prescriptions = relationship("Prescription", back_populates="medical_record")

class Appointment(Base):
    __tablename__ = 'APPOINTMENTS'
    
    appointment_id = Column('APPOINTMENTID', Integer, primary_key=True)
    patient_id = Column('PATIENTID', Integer, ForeignKey('PATIENTS.PATIENTID'))
    doctor_id = Column('DOCTORID', Integer, ForeignKey('DOCTORS.DOCTORID'))
    department_id = Column('DEPARTMENTID', Integer, ForeignKey('DEPARTMENTS.DEPARTMENTID'))
    appointment_date = Column('APPOINTMENTDATE', Date)
    appointment_time = Column('APPOINTMENTTIME', String(10))
    status = Column('STATUS', String(20))
    reason = Column('REASON', String(500))
    notes = Column('NOTES', String(500))
    
    # Relationships
    patient = relationship("Patient", back_populates="appointments")
    doctor = relationship("Doctor", back_populates="appointments")
    department = relationship("Department", back_populates="appointments")

class Prescription(Base):
    __tablename__ = 'PRESCRIPTIONS'
    
    prescription_id = Column('PRESCRIPTIONID', Integer, primary_key=True)
    record_id = Column('RECORDID', Integer, ForeignKey('MEDICALRECORDS.RECORDID'))
    patient_id = Column('PATIENTID', Integer, ForeignKey('PATIENTS.PATIENTID'))
    doctor_id = Column('DOCTORID', Integer, ForeignKey('DOCTORS.DOCTORID'))
    prescription_date = Column('PRESCRIPTIONDATE', Date)
    status = Column('STATUS', String(20))
    
    # Relationships
    medical_record = relationship("MedicalRecord", back_populates="prescriptions")
    patient = relationship("Patient", back_populates="prescriptions")
    doctor = relationship("Doctor", back_populates="prescriptions") 