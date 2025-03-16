-- Tạo các sequence để sinh ID tự động
CREATE SEQUENCE seq_facility START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_department START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_doctor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_staff START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_patient START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_appointment START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_record START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_prescription START WITH 1 INCREMENT BY 1;

-- Tạo bảng Facilities (Cơ sở)
CREATE TABLE Facilities (
    FacilityID NUMBER PRIMARY KEY,
    FacilityName VARCHAR2(100) NOT NULL,
    Location VARCHAR2(200) NOT NULL,
    ContactInfo VARCHAR2(100),
    ManagerID NUMBER NULL, -- Để NULL ban đầu, sẽ cập nhật sau
    Description VARCHAR2(500)
);

-- Tạo bảng Departments (Khoa) - Sửa lỗi với cột PhoneNumber
CREATE TABLE Departments (
    DepartmentID NUMBER PRIMARY KEY,
    DepartmentName VARCHAR2(100) NOT NULL,
    Location VARCHAR2(200),
    HeadDoctorID NUMBER NULL, -- Để NULL ban đầu, sẽ cập nhật sau
    Description VARCHAR2(500),
    PhoneNumber VARCHAR2(25), -- Tăng kích thước từ 20 lên 25
    FacilityID NUMBER,
    CONSTRAINT fk_dept_facility FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

-- Tạo bảng Doctors (Bác sĩ)
CREATE TABLE Doctors (
    DoctorID NUMBER PRIMARY KEY,
    FullName VARCHAR2(100) NOT NULL,
    DateOfBirth DATE,
    Gender VARCHAR2(10),
    Specialization VARCHAR2(100),
    DepartmentID NUMBER,
    LicenseNumber VARCHAR2(50) NOT NULL,
    ContactInfo VARCHAR2(100),
    Email VARCHAR2(100),
    HireDate DATE,
    Qualification VARCHAR2(200),
    CONSTRAINT fk_doctor_dept FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Staff (Nhân viên)
CREATE TABLE Staff (
    StaffID NUMBER PRIMARY KEY,
    FullName VARCHAR2(100) NOT NULL,
    DateOfBirth DATE,
    Gender VARCHAR2(10),
    Position VARCHAR2(100),
    DepartmentID NUMBER,
    ContactInfo VARCHAR2(100),
    Email VARCHAR2(100),
    HireDate DATE,
    CONSTRAINT fk_staff_dept FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Patients (Bệnh nhân)
CREATE TABLE Patients (
    PatientID NUMBER PRIMARY KEY,
    FullName VARCHAR2(100) NOT NULL,
    DateOfBirth DATE,
    Gender VARCHAR2(10),
    Address VARCHAR2(200),
    Phone VARCHAR2(20),
    Email VARCHAR2(100),
    InsuranceID VARCHAR2(50),
    BloodType VARCHAR2(10),
    EmergencyContact VARCHAR2(100),
    RegistrationDate DATE DEFAULT SYSDATE
);

-- Tạo bảng MedicalRecords (Bệnh án)
CREATE TABLE MedicalRecords (
    RecordID NUMBER PRIMARY KEY,
    PatientID NUMBER,
    DoctorID NUMBER,
    DateCreated DATE DEFAULT SYSDATE,
    Diagnosis VARCHAR2(500),
    Treatment VARCHAR2(500),
    Notes VARCHAR2(1000),
    CONSTRAINT fk_record_patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT fk_record_doctor FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Tạo bảng Appointments (Lịch khám)
CREATE TABLE Appointments (
    AppointmentID NUMBER PRIMARY KEY,
    PatientID NUMBER,
    DoctorID NUMBER,
    DepartmentID NUMBER,
    AppointmentDate DATE,
    AppointmentTime VARCHAR2(10),
    Status VARCHAR2(20) DEFAULT 'Scheduled',
    Reason VARCHAR2(500),
    Notes VARCHAR2(500),
    CONSTRAINT fk_appt_patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT fk_appt_doctor FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    CONSTRAINT fk_appt_dept FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Tạo bảng Prescriptions (Đơn thuốc)
CREATE TABLE Prescriptions (
    PrescriptionID NUMBER PRIMARY KEY,
    RecordID NUMBER,
    PatientID NUMBER,
    DoctorID NUMBER,
    PrescriptionDate DATE DEFAULT SYSDATE,
    Status VARCHAR2(20) DEFAULT 'Active',
    CONSTRAINT fk_prescription_record FOREIGN KEY (RecordID) REFERENCES MedicalRecords(RecordID),
    CONSTRAINT fk_prescription_patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT fk_prescription_doctor FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Thêm các ràng buộc khóa ngoại sau khi đã tạo đủ các bảng
ALTER TABLE Departments ADD CONSTRAINT fk_dept_doctor FOREIGN KEY (HeadDoctorID) REFERENCES Doctors(DoctorID);
ALTER TABLE Facilities ADD CONSTRAINT fk_facility_manager FOREIGN KEY (ManagerID) REFERENCES Staff(StaffID);

-- 1. Thêm dữ liệu vào bảng Facilities (ban đầu để ManagerID = NULL)
INSERT INTO Facilities (FacilityID, FacilityName, Location, ContactInfo, ManagerID, Description)
VALUES (seq_facility.NEXTVAL, 'Cơ sở chính Hà Nội', 'Số 1 Đường Giải Phóng, Hà Nội', '0243.123.4567', NULL, 'Trụ sở chính của bệnh viện');

INSERT INTO Facilities (FacilityID, FacilityName, Location, ContactInfo, ManagerID, Description)
VALUES (seq_facility.NEXTVAL, 'Cơ sở 2 Hà Nội', 'Số 43 Đường Trần Duy Hưng, Hà Nội', '0243.987.6543', NULL, 'Cơ sở khám chữa bệnh khu vực phía Tây');

INSERT INTO Facilities (FacilityID, FacilityName, Location, ContactInfo, ManagerID, Description)
VALUES (seq_facility.NEXTVAL, 'Cơ sở Đà Nẵng', '15 Nguyễn Văn Linh, Đà Nẵng', '0236.222.3333', NULL, 'Cơ sở khu vực miền Trung');

INSERT INTO Facilities (FacilityID, FacilityName, Location, ContactInfo, ManagerID, Description)
VALUES (seq_facility.NEXTVAL, 'Cơ sở Hồ Chí Minh', '215 Hồng Bàng, Quận 5, TP. HCM', '0283.111.2222', NULL, 'Cơ sở khu vực phía Nam');

INSERT INTO Facilities (FacilityID, FacilityName, Location, ContactInfo, ManagerID, Description)
VALUES (seq_facility.NEXTVAL, 'Trung tâm Y học Hạt nhân', 'Số 5 Đường Lê Duẩn, Hà Nội', '0243.666.7777', NULL, 'Trung tâm chuyên về ứng dụng kỹ thuật hạt nhân trong y học');

-- 2. Thêm dữ liệu vào bảng Departments (ban đầu để HeadDoctorID = NULL)
INSERT INTO Departments (DepartmentID, DepartmentName, Location, HeadDoctorID, Description, PhoneNumber, FacilityID)
VALUES (seq_department.NEXTVAL, 'Khoa Nội', 'Tầng 2, Nhà A', NULL, 'Khoa Nội tổng quát', '0243.123.4567-101', 1);

INSERT INTO Departments (DepartmentID, DepartmentName, Location, HeadDoctorID, Description, PhoneNumber, FacilityID)
VALUES (seq_department.NEXTVAL, 'Khoa Ngoại', 'Tầng 3, Nhà A', NULL, 'Khoa Ngoại tổng quát', '0243.123.4567-102', 1);

INSERT INTO Departments (DepartmentID, DepartmentName, Location, HeadDoctorID, Description, PhoneNumber, FacilityID)
VALUES (seq_department.NEXTVAL, 'Khoa Tim mạch', 'Tầng 4, Nhà B', NULL, 'Chuyên về các bệnh tim mạch', '0243.123.4567-103', 1);

INSERT INTO Departments (DepartmentID, DepartmentName, Location, HeadDoctorID, Description, PhoneNumber, FacilityID)
VALUES (seq_department.NEXTVAL, 'Khoa Sản', 'Tầng 2, Nhà C', NULL, 'Khoa Sản và Phụ khoa', '0243.123.4567-104', 1);

INSERT INTO Departments (DepartmentID, DepartmentName, Location, HeadDoctorID, Description, PhoneNumber, FacilityID)
VALUES (seq_department.NEXTVAL, 'Khoa Cấp cứu', 'Tầng 1, Nhà A', NULL, 'Khoa Cấp cứu 24/7', '0243.123.4567-105', 1);

INSERT INTO Departments (DepartmentID, DepartmentName, Location, HeadDoctorID, Description, PhoneNumber, FacilityID)
VALUES (seq_department.NEXTVAL, 'Khoa Nhi', 'Tầng 5, Nhà B', NULL, 'Chuyên khoa Nhi', '0243.123.4567-106', 1);

INSERT INTO Departments (DepartmentID, DepartmentName, Location, HeadDoctorID, Description, PhoneNumber, FacilityID)
VALUES (seq_department.NEXTVAL, 'Khoa Da liễu', 'Tầng 3, Nhà C', NULL, 'Chuyên khoa Da liễu', '0283.111.2222-201', 4);

INSERT INTO Departments (DepartmentID, DepartmentName, Location, HeadDoctorID, Description, PhoneNumber, FacilityID)
VALUES (seq_department.NEXTVAL, 'Khoa Răng Hàm Mặt', 'Tầng 2, Nhà D', NULL, 'Chuyên khoa Răng Hàm Mặt', '0283.111.2222-202', 4);

-- 3. Thêm dữ liệu vào bảng Doctors
INSERT INTO Doctors (DoctorID, FullName, DateOfBirth, Gender, Specialization, DepartmentID, LicenseNumber, ContactInfo, Email, HireDate, Qualification)
VALUES (seq_doctor.NEXTVAL, 'Nguyễn Văn An', TO_DATE('1975-05-10', 'YYYY-MM-DD'), 'Nam', 'Nội tổng quát', 1, 'MD12345', '0912.345.678', 'nguyenan@hospital.vn', TO_DATE('2010-06-15', 'YYYY-MM-DD'), 'Tiến sĩ Y khoa, Đại học Y Hà Nội');

INSERT INTO Doctors (DoctorID, FullName, DateOfBirth, Gender, Specialization, DepartmentID, LicenseNumber, ContactInfo, Email, HireDate, Qualification)
VALUES (seq_doctor.NEXTVAL, 'Trần Thị Bình', TO_DATE('1980-08-22', 'YYYY-MM-DD'), 'Nữ', 'Ngoại tổng quát', 2, 'MD23456', '0923.456.789', 'tranbinh@hospital.vn', TO_DATE('2012-03-10', 'YYYY-MM-DD'), 'Phó giáo sư, Tiến sĩ Y khoa');

INSERT INTO Doctors (DoctorID, FullName, DateOfBirth, Gender, Specialization, DepartmentID, LicenseNumber, ContactInfo, Email, HireDate, Qualification)
VALUES (seq_doctor.NEXTVAL, 'Lê Minh Cường', TO_DATE('1972-11-30', 'YYYY-MM-DD'), 'Nam', 'Tim mạch can thiệp', 3, 'MD34567', '0934.567.890', 'lecuong@hospital.vn', TO_DATE('2008-09-01', 'YYYY-MM-DD'), 'Giáo sư, Tiến sĩ Y khoa');

INSERT INTO Doctors (DoctorID, FullName, DateOfBirth, Gender, Specialization, DepartmentID, LicenseNumber, ContactInfo, Email, HireDate, Qualification)
VALUES (seq_doctor.NEXTVAL, 'Phạm Thị Dung', TO_DATE('1985-04-15', 'YYYY-MM-DD'), 'Nữ', 'Sản phụ khoa', 4, 'MD45678', '0945.678.901', 'phamdung@hospital.vn', TO_DATE('2015-02-20', 'YYYY-MM-DD'), 'Tiến sĩ Y khoa, Đại học Y Dược TPHCM');

INSERT INTO Doctors (DoctorID, FullName, DateOfBirth, Gender, Specialization, DepartmentID, LicenseNumber, ContactInfo, Email, HireDate, Qualification)
VALUES (seq_doctor.NEXTVAL, 'Hoàng Văn Em', TO_DATE('1978-12-05', 'YYYY-MM-DD'), 'Nam', 'Cấp cứu đa khoa', 5, 'MD56789', '0956.789.012', 'hoangem@hospital.vn', TO_DATE('2011-11-11', 'YYYY-MM-DD'), 'Thạc sĩ Y khoa, Chuyên gia Cấp cứu');

INSERT INTO Doctors (DoctorID, FullName, DateOfBirth, Gender, Specialization, DepartmentID, LicenseNumber, ContactInfo, Email, HireDate, Qualification)
VALUES (seq_doctor.NEXTVAL, 'Ngô Mỹ Tâm', TO_DATE('1983-02-18', 'YYYY-MM-DD'), 'Nữ', 'Nhi khoa', 6, 'MD67890', '0967.890.123', 'ngotam@hospital.vn', TO_DATE('2014-07-01', 'YYYY-MM-DD'), 'Tiến sĩ Y khoa, Chuyên gia Nhi');

INSERT INTO Doctors (DoctorID, FullName, DateOfBirth, Gender, Specialization, DepartmentID, LicenseNumber, ContactInfo, Email, HireDate, Qualification)
VALUES (seq_doctor.NEXTVAL, 'Đỗ Văn Giáp', TO_DATE('1976-09-28', 'YYYY-MM-DD'), 'Nam', 'Da liễu', 7, 'MD78901', '0978.901.234', 'dogiap@hospital.vn', TO_DATE('2009-04-15', 'YYYY-MM-DD'), 'Tiến sĩ Y khoa, Chuyên gia Da liễu');

INSERT INTO Doctors (DoctorID, FullName, DateOfBirth, Gender, Specialization, DepartmentID, LicenseNumber, ContactInfo, Email, HireDate, Qualification)
VALUES (seq_doctor.NEXTVAL, 'Vũ Thị Hạnh', TO_DATE('1981-06-12', 'YYYY-MM-DD'), 'Nữ', 'Răng Hàm Mặt', 8, 'MD89012', '0989.012.345', 'vuhanh@hospital.vn', TO_DATE('2013-08-01', 'YYYY-MM-DD'), 'Tiến sĩ Răng Hàm Mặt');

-- 4. Thêm dữ liệu vào bảng Staff
INSERT INTO Staff (StaffID, FullName, DateOfBirth, Gender, Position, DepartmentID, ContactInfo, Email, HireDate)
VALUES (seq_staff.NEXTVAL, 'Nguyễn Thị Mai', TO_DATE('1988-03-12', 'YYYY-MM-DD'), 'Nữ', 'Y tá trưởng', 1, '0912.123.123', 'ntmai@hospital.vn', TO_DATE('2015-06-01', 'YYYY-MM-DD'));

INSERT INTO Staff (StaffID, FullName, DateOfBirth, Gender, Position, DepartmentID, ContactInfo, Email, HireDate)
VALUES (seq_staff.NEXTVAL, 'Trần Văn Bảo', TO_DATE('1985-11-22', 'YYYY-MM-DD'), 'Nam', 'Kỹ thuật viên', 3, '0934.234.234', 'tvbao@hospital.vn', TO_DATE('2014-03-15', 'YYYY-MM-DD'));

INSERT INTO Staff (StaffID, FullName, DateOfBirth, Gender, Position, DepartmentID, ContactInfo, Email, HireDate)
VALUES (seq_staff.NEXTVAL, 'Lê Thị Hương', TO_DATE('1990-05-30', 'YYYY-MM-DD'), 'Nữ', 'Hộ lý', 4, '0956.345.345', 'lthuong@hospital.vn', TO_DATE('2016-08-10', 'YYYY-MM-DD'));

INSERT INTO Staff (StaffID, FullName, DateOfBirth, Gender, Position, DepartmentID, ContactInfo, Email, HireDate)
VALUES (seq_staff.NEXTVAL, 'Phạm Văn Dũng', TO_DATE('1978-12-15', 'YYYY-MM-DD'), 'Nam', 'Quản lý', 2, '0978.456.456', 'pvdung@hospital.vn', TO_DATE('2010-01-15', 'YYYY-MM-DD'));

INSERT INTO Staff (StaffID, FullName, DateOfBirth, Gender, Position, DepartmentID, ContactInfo, Email, HireDate)
VALUES (seq_staff.NEXTVAL, 'Hoàng Thị Lan', TO_DATE('1992-07-25', 'YYYY-MM-DD'), 'Nữ', 'Y tá', 5, '0991.567.567', 'htlan@hospital.vn', TO_DATE('2017-11-20', 'YYYY-MM-DD'));

INSERT INTO Staff (StaffID, FullName, DateOfBirth, Gender, Position, DepartmentID, ContactInfo, Email, HireDate)
VALUES (seq_staff.NEXTVAL, 'Vũ Đình Minh', TO_DATE('1987-09-18', 'YYYY-MM-DD'), 'Nam', 'Quản lý CNTT', 1, '0912.678.678', 'vdminh@hospital.vn', TO_DATE('2013-04-01', 'YYYY-MM-DD'));

INSERT INTO Staff (StaffID, FullName, DateOfBirth, Gender, Position, DepartmentID, ContactInfo, Email, HireDate)
VALUES (seq_staff.NEXTVAL, 'Đỗ Thị Hà', TO_DATE('1989-02-14', 'YYYY-MM-DD'), 'Nữ', 'Y tá', 6, '0934.789.789', 'dtha@hospital.vn', TO_DATE('2015-10-15', 'YYYY-MM-DD'));

INSERT INTO Staff (StaffID, FullName, DateOfBirth, Gender, Position, DepartmentID, ContactInfo, Email, HireDate)
VALUES (seq_staff.NEXTVAL, 'Ngô Văn Tùng', TO_DATE('1980-08-05', 'YYYY-MM-DD'), 'Nam', 'Quản lý cơ sở', 4, '0956.890.890', 'nvtung@hospital.vn', TO_DATE('2012-02-01', 'YYYY-MM-DD'));

-- 5. Cập nhật ManagerID trong Facilities và HeadDoctorID trong Departments
UPDATE Facilities SET ManagerID = 4 WHERE FacilityID = 1;
UPDATE Facilities SET ManagerID = 6 WHERE FacilityID = 2;
UPDATE Facilities SET ManagerID = 8 WHERE FacilityID = 3;
UPDATE Facilities SET ManagerID = 8 WHERE FacilityID = 4;
UPDATE Facilities SET ManagerID = 4 WHERE FacilityID = 5;

UPDATE Departments SET HeadDoctorID = 1 WHERE DepartmentID = 1;
UPDATE Departments SET HeadDoctorID = 2 WHERE DepartmentID = 2;
UPDATE Departments SET HeadDoctorID = 3 WHERE DepartmentID = 3;
UPDATE Departments SET HeadDoctorID = 4 WHERE DepartmentID = 4;
UPDATE Departments SET HeadDoctorID = 5 WHERE DepartmentID = 5;
UPDATE Departments SET HeadDoctorID = 6 WHERE DepartmentID = 6;
UPDATE Departments SET HeadDoctorID = 7 WHERE DepartmentID = 7;
UPDATE Departments SET HeadDoctorID = 8 WHERE DepartmentID = 8;

-- 6. Thêm dữ liệu vào bảng Patients
INSERT INTO Patients (PatientID, FullName, DateOfBirth, Gender, Address, Phone, Email, InsuranceID, BloodType, EmergencyContact, RegistrationDate)
VALUES (seq_patient.NEXTVAL, 'Nguyễn Văn Linh', TO_DATE('1965-07-15', 'YYYY-MM-DD'), 'Nam', '15 Nguyễn Trãi, Hà Nội', '0912.111.222', 'nvlinh@gmail.com', 'BH12345678', 'A+', 'Nguyễn Thị Lan - 0912.222.333', TO_DATE('2020-01-10', 'YYYY-MM-DD'));

INSERT INTO Patients (PatientID, FullName, DateOfBirth, Gender, Address, Phone, Email, InsuranceID, BloodType, EmergencyContact, RegistrationDate)
VALUES (seq_patient.NEXTVAL, 'Trần Thị Hoa', TO_DATE('1982-11-23', 'YYYY-MM-DD'), 'Nữ', '27 Lê Duẩn, Hà Nội', '0934.333.444', 'tthoa@gmail.com', 'BH23456789', 'B-', 'Trần Văn Bình - 0956.444.555', TO_DATE('2020-03-05', 'YYYY-MM-DD'));

INSERT INTO Patients (PatientID, FullName, DateOfBirth, Gender, Address, Phone, Email, InsuranceID, BloodType, EmergencyContact, RegistrationDate)
VALUES (seq_patient.NEXTVAL, 'Lê Minh Tuấn', TO_DATE('1975-03-05', 'YYYY-MM-DD'), 'Nam', '8 Nguyễn Huệ, Đà Nẵng', '0956.555.666', 'lmtuan@gmail.com', 'BH34567890', 'O+', 'Lê Thị Thu - 0978.666.777', TO_DATE('2021-05-20', 'YYYY-MM-DD'));

INSERT INTO Patients (PatientID, FullName, DateOfBirth, Gender, Address, Phone, Email, InsuranceID, BloodType, EmergencyContact, RegistrationDate)
VALUES (seq_patient.NEXTVAL, 'Phạm Thị Ngọc', TO_DATE('1990-09-18', 'YYYY-MM-DD'), 'Nữ', '45 Nguyễn Thị Minh Khai, TP. HCM', '0978.777.888', 'ptngoc@gmail.com', 'BH45678901', 'AB+', 'Phạm Văn Nam - 0991.888.999', TO_DATE('2021-08-12', 'YYYY-MM-DD'));

INSERT INTO Patients (PatientID, FullName, DateOfBirth, Gender, Address, Phone, Email, InsuranceID, BloodType, EmergencyContact, RegistrationDate)
VALUES (seq_patient.NEXTVAL, 'Hoàng Văn Minh', TO_DATE('1988-12-30', 'YYYY-MM-DD'), 'Nam', '12 Lý Thường Kiệt, Hà Nội', '0991.999.000', 'hvminh@gmail.com', 'BH56789012', 'A-', 'Hoàng Thị Lan - 0912.000.111', TO_DATE('2022-01-30', 'YYYY-MM-DD'));

-- 7. Thêm dữ liệu vào bảng MedicalRecords
INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, DateCreated, Diagnosis, Treatment, Notes)
VALUES (seq_record.NEXTVAL, 1, 1, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'Viêm phổi', 'Kháng sinh, nghỉ ngơi', 'Bệnh nhân cần tái khám sau 1 tuần');

INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, DateCreated, Diagnosis, Treatment, Notes)
VALUES (seq_record.NEXTVAL, 2, 4, TO_DATE('2023-02-20', 'YYYY-MM-DD'), 'Thai 32 tuần, thai phát triển bình thường', 'Vitamin bổ sung, chế độ dinh dưỡng', 'Siêu âm và tái khám định kỳ');

INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, DateCreated, Diagnosis, Treatment, Notes)
VALUES (seq_record.NEXTVAL, 3, 3, TO_DATE('2023-03-10', 'YYYY-MM-DD'), 'Tăng huyết áp độ 2', 'Thuốc hạ áp, chế độ ăn giảm muối', 'Theo dõi huyết áp hàng ngày, tái khám sau 2 tuần');

INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, DateCreated, Diagnosis, Treatment, Notes)
VALUES (seq_record.NEXTVAL, 4, 7, TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'Viêm da cơ địa', 'Thuốc kháng viêm, kem bôi', 'Tránh các tác nhân gây dị ứng, tái khám nếu không đỡ');

INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, DateCreated, Diagnosis, Treatment, Notes)
VALUES (seq_record.NEXTVAL, 5, 5, TO_DATE('2023-05-12', 'YYYY-MM-DD'), 'Gãy xương đòn', 'Bó bột, giảm đau', 'Chụp X-quang kiểm tra sau 4 tuần');

-- 8. Thêm dữ liệu vào bảng Appointments
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, DepartmentID, AppointmentDate, AppointmentTime, Status, Reason, Notes)
VALUES (seq_appointment.NEXTVAL, 1, 1, 1, TO_DATE('2023-01-22', 'YYYY-MM-DD'), '09:00', 'Completed', 'Tái khám viêm phổi', 'Bệnh nhân đã khỏi');

INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, DepartmentID, AppointmentDate, AppointmentTime, Status, Reason, Notes)
VALUES (seq_appointment.NEXTVAL, 2, 4, 4, TO_DATE('2023-03-15', 'YYYY-MM-DD'), '10:30', 'Completed', 'Khám thai định kỳ', 'Thai nhi phát triển tốt');

INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, DepartmentID, AppointmentDate, AppointmentTime, Status, Reason, Notes)
VALUES (seq_appointment.NEXTVAL, 3, 3, 3, TO_DATE('2023-03-24', 'YYYY-MM-DD'), '14:00', 'Completed', 'Tái khám tăng huyết áp', 'Cần điều chỉnh liều thuốc');

INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, DepartmentID, AppointmentDate, AppointmentTime, Status, Reason, Notes)
VALUES (seq_appointment.NEXTVAL, 4, 7, 7, TO_DATE('2023-04-20', 'YYYY-MM-DD'), '11:15', 'Completed', 'Tái khám viêm da', 'Tình trạng đã cải thiện');

INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, DepartmentID, AppointmentDate, AppointmentTime, Status, Reason, Notes)
VALUES (seq_appointment.NEXTVAL, 5, 5, 5, TO_DATE('2023-06-10', 'YYYY-MM-DD'), '08:30', 'Scheduled', 'Kiểm tra xương đòn', 'Cần chụp X-quang mới');

-- 9. Thêm dữ liệu vào bảng Prescriptions
INSERT INTO Prescriptions (PrescriptionID, RecordID, PatientID, DoctorID, PrescriptionDate, Status)
VALUES (seq_prescription.NEXTVAL, 1, 1, 1, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'Completed');

INSERT INTO Prescriptions (PrescriptionID, RecordID, PatientID, DoctorID, PrescriptionDate, Status)
VALUES (seq_prescription.NEXTVAL, 2, 2, 4, TO_DATE('2023-02-20', 'YYYY-MM-DD'), 'Completed');

INSERT INTO Prescriptions (PrescriptionID, RecordID, PatientID, DoctorID, PrescriptionDate, Status)
VALUES (seq_prescription.NEXTVAL, 3, 3, 3, TO_DATE('2023-03-10', 'YYYY-MM-DD'), 'Active');

INSERT INTO Prescriptions (PrescriptionID, RecordID, PatientID, DoctorID, PrescriptionDate, Status)
VALUES (seq_prescription.NEXTVAL, 4, 4, 7, TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'Active');

INSERT INTO Prescriptions (PrescriptionID, RecordID, PatientID, DoctorID, PrescriptionDate, Status)
VALUES (seq_prescription.NEXTVAL, 5, 5, 5, TO_DATE('2023-05-12', 'YYYY-MM-DD'), 'Active');

-- Xác nhận các thay đổi
COMMIT;

SELECT * FROM Facilities;
SELECT * FROM Departments;
SELECT * FROM Doctors;
SELECT * FROM Staff;
SELECT * FROM Patients;
SELECT * FROM MedicalRecords;
SELECT * FROM Appointments;
SELECT * FROM Prescriptions;
