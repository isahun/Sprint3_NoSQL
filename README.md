# DBaaS – Cloud Deployment with MongoDB Atlas

## 📌 Description

This project is part of a DBaaS (Database as a Service) deployment activity using MongoDB Atlas.

The objective is to create a cloud database instance, configure secure access, and import sample data using an embedded NoSQL data model.

---

## 🎯 Objectives

- Create a free M0 cluster in MongoDB Atlas
- Configure a database user
- Configure IP network access
- Connect using MongoDB Compass
- Import a JSON file with sample data
- Validate the setup through queries

---

## 🛠 Technologies Used

- MongoDB Atlas (DBaaS)
- MongoDB Compass
- JSON
- HTML (exercise documentation)

---

## 🗂 Project Structure
├── dbaas-atlas.html
├── articles.json
├── screens/
└── README.md

---

## 🧱 Data Model

The `articles` collection follows an embedded document model with the following structure:

- `title`
- `content`
- `publication_date`
- `author` (embedded object)
- `comments` (array of embedded objects)

This model optimizes read performance by avoiding join operations typical in relational databases.

---

## ☁️ Deployment

A free M0 cluster was created in MongoDB Atlas with:

- SCRAM authentication
- `atlasAdmin` role
- Network access configured using `0.0.0.0/0` (academic environment)

The connection was established using MongoDB Compass with the connection string provided by Atlas.

---

## ✅ Results

- `blog` database successfully created
- `articles` collection imported with multiple documents
- Queries executed successfully
- Embedded model validated in a DBaaS environment

---

## 📚 Conclusion

Deploying the database using a DBaaS solution removes the need to manage local infrastructure, improves scalability, and enables remote access from multiple devices.

The objectives of the activity were successfully achieved.