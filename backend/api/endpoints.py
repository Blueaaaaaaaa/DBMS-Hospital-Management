from flask import Blueprint, jsonify, request
from sqlalchemy.orm import joinedload
from ..models.models import Facility, Department, Doctor, Staff, Patient, MedicalRecord, Appointment, Prescription
from ..services.db_service import get_session

# Create API Blueprint
api = Blueprint('api', __name__)

# Helper function to convert SQLAlchemy models to dict
def model_to_dict(model):
    result = {}
    for column in model.__table__.columns:
        value = getattr(model, column.name)
        result[column.name] = value
    return result

# Facilities Endpoints
@api.route('/facilities', methods=['GET'])
def get_facilities():
    """Get all facilities"""
    with get_session() as session:
        facilities = session.query(Facility).all()
        result = [model_to_dict(facility) for facility in facilities]
        return jsonify(result)

@api.route('/facilities/<int:facility_id>', methods=['GET'])
def get_facility(facility_id):
    """Get a facility by ID"""
    with get_session() as session:
        facility = session.query(Facility).filter(Facility.facility_id == facility_id).first()
        if not facility:
            return jsonify({"error": "Facility not found"}), 404
        return jsonify(model_to_dict(facility))

@api.route('/facilities/<int:facility_id>/departments', methods=['GET'])
def get_facility_departments(facility_id):
    """Get departments in a facility"""
    with get_session() as session:
        departments = session.query(Department).filter(Department.facility_id == facility_id).all()
        result = [model_to_dict(department) for department in departments]
        return jsonify(result)

# Departments Endpoints
@api.route('/departments', methods=['GET'])
def get_departments():
    """Get all departments"""
    with get_session() as session:
        departments = session.query(Department).all()
        result = [model_to_dict(department) for department in departments]
        return jsonify(result)

@api.route('/departments/<int:department_id>', methods=['GET'])
def get_department(department_id):
    """Get a department by ID"""
    with get_session() as session:
        department = session.query(Department).filter(Department.department_id == department_id).first()
        if not department:
            return jsonify({"error": "Department not found"}), 404
        return jsonify(model_to_dict(department))

@api.route('/departments/<int:department_id>/doctors', methods=['GET'])
def get_department_doctors(department_id):
    """Get doctors in a department"""
    with get_session() as session:
        doctors = session.query(Doctor).filter(Doctor.department_id == department_id).all()
        result = [model_to_dict(doctor) for doctor in doctors]
        return jsonify(result)

@api.route('/departments/<int:department_id>/staff', methods=['GET'])
def get_department_staff(department_id):
    """Get staff in a department"""
    with get_session() as session:
        staff = session.query(Staff).filter(Staff.department_id == department_id).all()
        result = [model_to_dict(staff_member) for staff_member in staff]
        return jsonify(result)

# Doctors Endpoints
@api.route('/doctors', methods=['GET'])
def get_doctors():
    """Get all doctors"""
    with get_session() as session:
        doctors = session.query(Doctor).all()
        result = [model_to_dict(doctor) for doctor in doctors]
        return jsonify(result)

@api.route('/doctors/<int:doctor_id>', methods=['GET'])
def get_doctor(doctor_id):
    """Get a doctor by ID"""
    with get_session() as session:
        doctor = session.query(Doctor).filter(Doctor.doctor_id == doctor_id).first()
        if not doctor:
            return jsonify({"error": "Doctor not found"}), 404
        return jsonify(model_to_dict(doctor))

@api.route('/doctors/<int:doctor_id>/appointments', methods=['GET'])
def get_doctor_appointments(doctor_id):
    """Get appointments for a doctor"""
    with get_session() as session:
        appointments = session.query(Appointment).filter(Appointment.doctor_id == doctor_id).all()
        result = [model_to_dict(appointment) for appointment in appointments]
        return jsonify(result)

# Patients Endpoints
@api.route('/patients', methods=['GET'])
def get_patients():
    """Get all patients"""
    with get_session() as session:
        patients = session.query(Patient).all()
        result = [model_to_dict(patient) for patient in patients]
        return jsonify(result)

@api.route('/patients/<int:patient_id>', methods=['GET'])
def get_patient(patient_id):
    """Get a patient by ID"""
    with get_session() as session:
        patient = session.query(Patient).filter(Patient.patient_id == patient_id).first()
        if not patient:
            return jsonify({"error": "Patient not found"}), 404
        return jsonify(model_to_dict(patient))

@api.route('/patients/<int:patient_id>/medical_records', methods=['GET'])
def get_patient_records(patient_id):
    """Get medical records for a patient"""
    with get_session() as session:
        records = session.query(MedicalRecord).filter(MedicalRecord.patient_id == patient_id).all()
        result = [model_to_dict(record) for record in records]
        return jsonify(result)

@api.route('/patients/<int:patient_id>/appointments', methods=['GET'])
def get_patient_appointments(patient_id):
    """Get appointments for a patient"""
    with get_session() as session:
        appointments = session.query(Appointment).filter(Appointment.patient_id == patient_id).all()
        result = [model_to_dict(appointment) for appointment in appointments]
        return jsonify(result)

# Medical Records Endpoints
@api.route('/medical_records', methods=['GET'])
def get_medical_records():
    """Get all medical records"""
    with get_session() as session:
        records = session.query(MedicalRecord).all()
        result = [model_to_dict(record) for record in records]
        return jsonify(result)

@api.route('/medical_records/<int:record_id>', methods=['GET'])
def get_medical_record(record_id):
    """Get a medical record by ID"""
    with get_session() as session:
        record = session.query(MedicalRecord).filter(MedicalRecord.record_id == record_id).first()
        if not record:
            return jsonify({"error": "Medical record not found"}), 404
        return jsonify(model_to_dict(record))

# Appointments Endpoints
@api.route('/appointments', methods=['GET'])
def get_appointments():
    """Get all appointments"""
    with get_session() as session:
        appointments = session.query(Appointment).all()
        result = [model_to_dict(appointment) for appointment in appointments]
        return jsonify(result)

@api.route('/appointments/<int:appointment_id>', methods=['GET'])
def get_appointment(appointment_id):
    """Get an appointment by ID"""
    with get_session() as session:
        appointment = session.query(Appointment).filter(Appointment.appointment_id == appointment_id).first()
        if not appointment:
            return jsonify({"error": "Appointment not found"}), 404
        return jsonify(model_to_dict(appointment))

# Dashboard statistics endpoints
@api.route('/stats/departments', methods=['GET'])
def get_department_stats():
    """Get department statistics"""
    with get_session() as session:
        # Count doctors and staff per department
        departments = session.query(Department).all()
        result = []
        
        for dept in departments:
            doctors_count = session.query(Doctor).filter(Doctor.department_id == dept.department_id).count()
            staff_count = session.query(Staff).filter(Staff.department_id == dept.department_id).count()
            
            dept_dict = model_to_dict(dept)
            dept_dict['doctors_count'] = doctors_count
            dept_dict['staff_count'] = staff_count
            result.append(dept_dict)
            
        return jsonify(result)

@api.route('/stats/appointments', methods=['GET'])
def get_appointment_stats():
    """Get appointment statistics"""
    with get_session() as session:
        # Count appointments by status
        statuses = ['Scheduled', 'Completed', 'Cancelled']
        result = []
        
        for status in statuses:
            count = session.query(Appointment).filter(Appointment.status == status).count()
            result.append({
                'status': status,
                'count': count
            })
            
        return jsonify(result)

@api.route('/stats/patients', methods=['GET'])
def get_patient_stats():
    """Get patient statistics"""
    with get_session() as session:
        # Count patients by gender and registration year
        total_patients = session.query(Patient).count()
        male_patients = session.query(Patient).filter(Patient.gender == 'Nam').count()
        female_patients = session.query(Patient).filter(Patient.gender == 'Nữ').count()
        
        result = {
            'total': total_patients,
            'gender_distribution': {
                'male': male_patients,
                'female': female_patients
            }
        }
        
        return jsonify(result) 