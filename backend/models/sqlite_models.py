from sqlalchemy import Column, Integer, String, Date, ForeignKey, Text, Float, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker
import os
import datetime

Base = declarative_base()

class Facility(Base):
    __tablename__ = 'facilities'
    
    facility_id = Column(Integer, primary_key=True)
    facility_name = Column(String(100), nullable=False)
    location = Column(String(200), nullable=False)
    contact_info = Column(String(100))
    manager_id = Column(Integer, ForeignKey('staff.staff_id'))
    description = Column(String(500))
    
    # Relationships
    departments = relationship("Department", back_populates="facility")
    manager = relationship("Staff", foreign_keys=[manager_id])

class Department(Base):
    __tablename__ = 'departments'
    
    department_id = Column(Integer, primary_key=True)
    department_name = Column(String(100), nullable=False)
    location = Column(String(200))
    head_doctor_id = Column(Integer, ForeignKey('doctors.doctor_id'))
    description = Column(String(500))
    phone_number = Column(String(25))
    facility_id = Column(Integer, ForeignKey('facilities.facility_id'))
    
    # Relationships
    facility = relationship("Facility", back_populates="departments")
    head_doctor = relationship("Doctor", foreign_keys=[head_doctor_id])
    doctors = relationship("Doctor", back_populates="department", foreign_keys="[Doctor.department_id]")
    staff = relationship("Staff", back_populates="department")
    appointments = relationship("Appointment", back_populates="department")

class Doctor(Base):
    __tablename__ = 'doctors'
    
    doctor_id = Column(Integer, primary_key=True)
    full_name = Column(String(100), nullable=False)
    date_of_birth = Column(Date)
    gender = Column(String(10))
    specialization = Column(String(100))
    department_id = Column(Integer, ForeignKey('departments.department_id'))
    license_number = Column(String(50), nullable=False)
    contact_info = Column(String(100))
    email = Column(String(100))
    hire_date = Column(Date)
    qualification = Column(String(200))
    
    # Relationships
    department = relationship("Department", back_populates="doctors", foreign_keys=[department_id])
    medical_records = relationship("MedicalRecord", back_populates="doctor")
    appointments = relationship("Appointment", back_populates="doctor")
    prescriptions = relationship("Prescription", back_populates="doctor")

class Staff(Base):
    __tablename__ = 'staff'
    
    staff_id = Column(Integer, primary_key=True)
    full_name = Column(String(100), nullable=False)
    date_of_birth = Column(Date)
    gender = Column(String(10))
    position = Column(String(100))
    department_id = Column(Integer, ForeignKey('departments.department_id'))
    contact_info = Column(String(100))
    email = Column(String(100))
    hire_date = Column(Date)
    
    # Relationships
    department = relationship("Department", back_populates="staff")
    managed_facilities = relationship("Facility", foreign_keys=[Facility.manager_id])

class Patient(Base):
    __tablename__ = 'patients'
    
    patient_id = Column(Integer, primary_key=True)
    full_name = Column(String(100), nullable=False)
    date_of_birth = Column(Date)
    gender = Column(String(10))
    address = Column(String(200))
    phone = Column(String(20))
    email = Column(String(100))
    insurance_id = Column(String(50))
    blood_type = Column(String(10))
    emergency_contact = Column(String(100))
    registration_date = Column(Date)
    
    # Relationships
    medical_records = relationship("MedicalRecord", back_populates="patient")
    appointments = relationship("Appointment", back_populates="patient")
    prescriptions = relationship("Prescription", back_populates="patient")

class MedicalRecord(Base):
    __tablename__ = 'medical_records'
    
    record_id = Column(Integer, primary_key=True)
    patient_id = Column(Integer, ForeignKey('patients.patient_id'))
    doctor_id = Column(Integer, ForeignKey('doctors.doctor_id'))
    date_created = Column(Date)
    diagnosis = Column(String(500))
    treatment = Column(String(500))
    notes = Column(String(1000))
    
    # Relationships
    patient = relationship("Patient", back_populates="medical_records")
    doctor = relationship("Doctor", back_populates="medical_records")
    prescriptions = relationship("Prescription", back_populates="medical_record")

class Appointment(Base):
    __tablename__ = 'appointments'
    
    appointment_id = Column(Integer, primary_key=True)
    patient_id = Column(Integer, ForeignKey('patients.patient_id'))
    doctor_id = Column(Integer, ForeignKey('doctors.doctor_id'))
    department_id = Column(Integer, ForeignKey('departments.department_id'))
    appointment_date = Column(Date)
    appointment_time = Column(String(10))
    status = Column(String(20))
    reason = Column(String(500))
    notes = Column(String(500))
    
    # Relationships
    patient = relationship("Patient", back_populates="appointments")
    doctor = relationship("Doctor", back_populates="appointments")
    department = relationship("Department", back_populates="appointments")

class Prescription(Base):
    __tablename__ = 'prescriptions'
    
    prescription_id = Column(Integer, primary_key=True)
    record_id = Column(Integer, ForeignKey('medical_records.record_id'))
    patient_id = Column(Integer, ForeignKey('patients.patient_id'))
    doctor_id = Column(Integer, ForeignKey('doctors.doctor_id'))
    prescription_date = Column(Date)
    status = Column(String(20))
    
    # Relationships
    medical_record = relationship("MedicalRecord", back_populates="prescriptions")
    patient = relationship("Patient", back_populates="prescriptions")
    doctor = relationship("Doctor", back_populates="prescriptions")

# Setup and initialize SQLite database with some sample data
def initialize_sqlite_db(db_path):
    engine = create_engine(f'sqlite:///{db_path}')
    Base.metadata.create_all(engine)
    
    # Create a session
    Session = sessionmaker(bind=engine)
    session = Session()
    
    # Check if we need to add sample data (if tables are empty)
    if session.query(Facility).count() == 0:
        # Add sample data
        print("Adding sample data to SQLite database...")
        
        # Add facilities
        facility1 = Facility(
            facility_name="Vietnam National Hospital - Main Campus", 
            location="Hanoi, Vietnam",
            contact_info="(+84) 123-456-789", 
            description="Main hospital campus with all departments and services"
        )
        
        facility2 = Facility(
            facility_name="Vietnam National Hospital - South Wing", 
            location="Ho Chi Minh City, Vietnam",
            contact_info="(+84) 987-654-321", 
            description="Southern branch specialized in tropical diseases"
        )
        
        session.add_all([facility1, facility2])
        session.commit()
        
        # Add departments
        dept1 = Department(
            department_name="Cardiology", 
            location="Building A, Floor 3",
            description="Heart and cardiovascular care",
            phone_number="(+84) 123-456-7890",
            facility_id=facility1.facility_id
        )
        
        dept2 = Department(
            department_name="Orthopedics", 
            location="Building B, Floor 2",
            description="Bone and joint care",
            phone_number="(+84) 123-456-7891",
            facility_id=facility1.facility_id
        )
        
        dept3 = Department(
            department_name="Pediatrics", 
            location="Building C, Floor 1",
            description="Children's healthcare",
            phone_number="(+84) 123-456-7892",
            facility_id=facility2.facility_id
        )
        
        session.add_all([dept1, dept2, dept3])
        session.commit()
        
        # Add doctors
        doctor1 = Doctor(
            full_name="Dr. Nguyen Van A",
            date_of_birth=datetime.date(1975, 5, 15),
            gender="Nam",
            specialization="Cardiology",
            department_id=dept1.department_id,
            license_number="VN12345",
            contact_info="(+84) 987-123-456",
            email="dr.nguyena@hospital.vn",
            hire_date=datetime.date(2010, 6, 1),
            qualification="MD, PhD Cardiovascular Medicine"
        )
        
        doctor2 = Doctor(
            full_name="Dr. Tran Thi B",
            date_of_birth=datetime.date(1980, 8, 22),
            gender="Nữ",
            specialization="Orthopedic Surgery",
            department_id=dept2.department_id,
            license_number="VN23456",
            contact_info="(+84) 987-234-567",
            email="dr.tranb@hospital.vn",
            hire_date=datetime.date(2012, 3, 15),
            qualification="MD, Orthopedic Surgery"
        )
        
        session.add_all([doctor1, doctor2])
        session.commit()
        
        # Add staff
        staff1 = Staff(
            full_name="Pham Van C",
            date_of_birth=datetime.date(1985, 3, 10),
            gender="Nam",
            position="Head Nurse",
            department_id=dept1.department_id,
            contact_info="(+84) 987-345-678",
            email="phamc@hospital.vn",
            hire_date=datetime.date(2015, 2, 1)
        )
        
        staff2 = Staff(
            full_name="Le Thi D",
            date_of_birth=datetime.date(1990, 11, 5),
            gender="Nữ",
            position="Administrator",
            department_id=dept2.department_id,
            contact_info="(+84) 987-456-789",
            email="led@hospital.vn",
            hire_date=datetime.date(2018, 7, 1)
        )
        
        session.add_all([staff1, staff2])
        session.commit()
        
        # Update facility with manager
        facility1.manager_id = staff2.staff_id
        session.commit()
        
        # Update department with head doctor
        dept1.head_doctor_id = doctor1.doctor_id
        dept2.head_doctor_id = doctor2.doctor_id
        session.commit()
        
        # Add patients
        patient1 = Patient(
            full_name="Hoang Van E",
            date_of_birth=datetime.date(1965, 7, 25),
            gender="Nam",
            address="123 Nguyen Street, Hanoi",
            phone="(+84) 987-567-890",
            email="hoange@example.com",
            insurance_id="INS12345",
            blood_type="O+",
            emergency_contact="Wife: (+84) 987-567-891",
            registration_date=datetime.date(2019, 5, 10)
        )
        
        patient2 = Patient(
            full_name="Nguyen Thi F",
            date_of_birth=datetime.date(1978, 4, 12),
            gender="Nữ",
            address="456 Tran Street, Ho Chi Minh City",
            phone="(+84) 987-678-901",
            email="nguyenf@example.com",
            insurance_id="INS23456",
            blood_type="A-",
            emergency_contact="Husband: (+84) 987-678-902",
            registration_date=datetime.date(2020, 3, 15)
        )
        
        session.add_all([patient1, patient2])
        session.commit()
        
        # Add appointments
        appointment1 = Appointment(
            patient_id=patient1.patient_id,
            doctor_id=doctor1.doctor_id,
            department_id=dept1.department_id,
            appointment_date=datetime.date.today() + datetime.timedelta(days=5),
            appointment_time="10:00",
            status="Scheduled",
            reason="Annual heart checkup",
            notes="Patient has history of high blood pressure"
        )
        
        appointment2 = Appointment(
            patient_id=patient2.patient_id,
            doctor_id=doctor2.doctor_id,
            department_id=dept2.department_id,
            appointment_date=datetime.date.today() - datetime.timedelta(days=10),
            appointment_time="14:30",
            status="Completed",
            reason="Follow-up after knee surgery",
            notes="Patient is recovering well"
        )
        
        appointment3 = Appointment(
            patient_id=patient1.patient_id,
            doctor_id=doctor2.doctor_id,
            department_id=dept2.department_id,
            appointment_date=datetime.date.today() + datetime.timedelta(days=15),
            appointment_time="11:15",
            status="Scheduled",
            reason="Back pain consultation",
            notes="First visit for this issue"
        )
        
        session.add_all([appointment1, appointment2, appointment3])
        session.commit()
        
        # Add medical records
        record1 = MedicalRecord(
            patient_id=patient2.patient_id,
            doctor_id=doctor2.doctor_id,
            date_created=datetime.date.today() - datetime.timedelta(days=10),
            diagnosis="Post-operative knee assessment",
            treatment="Physical therapy, pain management",
            notes="Patient showing good healing progress. Recommended continued physical therapy for 4 weeks."
        )
        
        session.add(record1)
        session.commit()
        
        # Add prescription
        prescription1 = Prescription(
            record_id=record1.record_id,
            patient_id=patient2.patient_id,
            doctor_id=doctor2.doctor_id,
            prescription_date=datetime.date.today() - datetime.timedelta(days=10),
            status="Filled"
        )
        
        session.add(prescription1)
        session.commit()
        
        print("Sample data added successfully")
    
    session.close()
    return engine 