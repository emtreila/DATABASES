# Music School Management Database (SQL Server)

This repository contains my coursework for the **Databases** class at **UBB (Universitatea Babeș–Bolyai)**, 2nd year.  
The project implements a complete SQL Server database for managing a **Music School**, covering schema creation, data manipulation, queries, stored procedures, and schema versioning.  
All scripts are written for **Microsoft SQL Server** and can be executed using **SQL Server Management Studio (SSMS)**.

---

# Project Description

The database models core activities of a music school, including:

### **Teachers**
- identity information  
- assigned instruments and lessons  

### **Students**
- personal data  
- enrolled lessons (many-to-many)  
- performance participation  

### **Instruments**
- instrument catalog  
- rentals to students  

### **Lessons & Scheduling**
- lesson details  
- teacher and instrument assignment  
- room booking and timetable  

### **Rooms**
- room metadata and capacity  

### **Performances**
- event details  
- participating students and their roles  

### **Grades**
- evaluation of students in lessons  

---

# Features Implemented

## **1. Database Schema (`create_tables.sql`)**
Defines all base tables and relationships:
- primary keys and foreign keys  
- many-to-many linking tables  
- check constraints  
- identity columns  
- relational integrity rules  

---

## **2. Data Population (`insert.sql`)**
Populates the database with sample data:
- teachers  
- students  
- instruments  
- lessons  
- schedules  
- grades  
- rentals  
- performances  

---

## **3. Query Examples (`select.sql`)**
Demonstrates multiple query types:
- JOIN operations (INNER / LEFT)  
- GROUP BY and HAVING  
- subqueries and filtering  
- multi-table queries across many-to-many relationships  

---

## **4. Data Modification (`update_delete.sql`)**
Includes controlled update and delete operations:
- conditional UPDATE  
- DELETE with joins  
- integrity-preserving changes  

---

## **5. Stored Procedures (`procedures.sql`)**
Implements procedural logic and a complete **schema versioning system**, including:
- forward migration procedures (`do_proc_1` → `do_proc_7`)  
- backward migration procedures (`undo_proc_1` → `undo_proc_7`)  
- version tracking table (`VersionTable`)  
- migration mapping table (`Procedures_Table`)  
- main controller procedure `goToVersion` for upgrading/downgrading schema versions  

---
