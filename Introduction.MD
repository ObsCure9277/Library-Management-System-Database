
# Library Management System

## Background of the System

The library management system integrates both physical and digital library operations to provide a seamless experience for users.

- **Physical Library:** Serves walk-in visitors who prefer to browse bookshelves, engage in quiet study spaces, and access printed resources directly.
- **Digital Library:** Expands accessibility, enabling users to search for books, borrow ebooks, and access research materials from anywhere.

This dual-platform approach leverages modern technology to bridge the gap between traditional library services and digital accessibility. The system ensures:
	- Synchronized inventory management to prevent book shortages or duplicate checkouts
	- User-friendly interface for online users to browse the catalog, reserve books, and manage borrowings
	- Digital membership services
	- Real-time updates on book availability
	- Automated reminders for due dates

## Type of System

The library management system is an online system built on an **SQL database** to efficiently manage and support library operations. It leverages a relational database to store and organize essential data:

- Book inventory
- User accounts
- Borrowing records
- Transaction history

The SQL database serves as the backbone, ensuring reliable data storage, retrieval, and management. Key features include:

- Seamless synchronization of book availability
- Real-time updates on checked-out and available materials
- User account management
- Secure access control
- Book reservations
- Borrowing history tracking
- Automated reminders for due dates
- Data consistency, scalability, and ease of maintenance

## List of Modules

### 1. Membership Registration Module
	- **User Sign-up:** Register new users with personal details
	- **Membership ID Generation:** Automatically generate unique membership IDs

### 2. Track Membership Validity Module (Active or Expired)
	- **Expiry Tracking:** Monitor membership status and restrict expired memberships
	- **Insights:** Overview of membership status, expiration date, and renewal options

### 3. Borrowing and Returning Process Module
	- **Book Checkout:** Borrow books by membership ID and book code
	- **Return Processing:** Update system when books are returned

### 4. Allow Members to Reserve Books Module
	- **Book Reservation Requests:** Reserve books currently checked out
	- **Reservation Status Tracking:** Check status and estimated availability

### 5. Track Due Dates and Overdue Books Module
	- **Due Date Calculation:** Assign and display due dates
	- **Penalty Tracking:** Log overdue books and fines

### 6. Process Fines Module (Calculate Late Fees Payment)
	- **Fine Calculation:** Compute late fees based on overdue days
	- **Payment Processing:** Pay fines online or in-person

### 7. Generate Fine Invoices for Members Module
	- **Invoice Generation:** Create detailed invoices for overdue fines
	- **Invoice History:** Record and review payment history

### 8. Extend the Book Loan Period
	- **Online Renewal Requests:** Request loan extension online
	- **Eligibility Check:** Verify eligibility for renewal

### 9. Enable Advanced Search Options for Books
	- **Filtered Search:** Refine searches by genre, author, popularity
	- **Advanced Sorting Options:** Sort by genre rank or most borrowed

### 10. Track Staff Performance and Shift Schedules Module
	- **Work Shift Management:** Maintain staff schedules
	- **Performance Tracking:** Record staff activities and evaluate efficiency

---

# Entity-Relationship Modeling

## Business Rules and Assumptions

- Each user can register as a library member by providing necessary personal details, and each membership is unique to one user. *(One to One)*
- Each member can borrow one or multiple books, but the total borrowed books must not exceed the allowed borrowing limit. *(One to Many)*
- Each book can be borrowed by only one member at a time, but the same book can be borrowed multiple times by different members. *(Many to Many)*
- Each membership has an expiration date, and expired memberships cannot borrow or reserve books until renewal.
- Reserved books are allocated on a first-come, first-served basis, and members must collect them within the designated time frame.
- Each borrowed book has a due date, and overdue books will incur a fine based on the number of late days.
- Members must clear all outstanding fines before borrowing new books or renewing their membership.
- Books must be returned in good condition; damaged or lost books may require compensation as per library policy.
- Staff members must follow scheduled shifts and maintain accurate records of book transactions and user interactions.
- Library staff must verify the quality and condition of books before lending or re-shelving them.
- The system must generate an invoice for all fines, and payment can be made online or at the library counter.
- The system must provide an advanced book search function, allowing filtering by genre, author, publication year, and popularity.

### Assumptions

- The maximum number of borrowed books by each member is up to **5**.
- The library has predefined operating hours, and loans, returns, and reservations must occur within those hours.
- Each book has a unique identifier to track borrowing history and availability.
- A book’s popularity is determined based on the number of times it has been borrowed.
- The fine calculation is based on a fixed rate per overdue day.
- The fine is automatically applied when a book is overdue.
- Staff members have assigned shifts, and their schedules cannot overlap with others on the same task.
- Time slots are predefined for staff scheduling, ensuring seamless operations throughout the day.
- Reservation and loan data are updated in real-time to prevent double bookings.
- Only staff can modify book inventory, approve loan extensions, or override fines.
- Staff are responsible for ensuring book stock levels and updating records if books are removed or added.
- Books returned before the due date can be borrowed by other members who reserved the books immediately.
- A book loan is considered active until it is marked as returned in the system.
- Members return the same quantity of the books they have borrowed every time.
- Members pay the exact amount of fine every time.
- Maximum **14 days** book loans extension is allowed.

