# Inventix iOS App

Inventix is an iOS application built with SwiftUI to help small business owners who do not have advantage knowledge of technology to manage inventory efficiently. This app enables users to keep track of their inventory items, categorize them, and perform various actions such as adding, editing, and deleting items.

## Features

- **Intuitive Interface**: Inventix provides a clean and intuitive user interface designed with SwiftUI, ensuring a smooth and enjoyable user experience.
  
- **Inventory Management**: Users can easily add new items to their inventory, edit existing ones, and delete items that are no longer needed.
  
- **Categorization**: Items can be categorized into different groups or categories for better organization and easier access.

- **Search Functionality**: Inventix includes a search feature that allows users to quickly find specific items by searching for their names or attributes.

- **Data Persistence**: The app utilizes Core Data for data persistence, ensuring that inventory data is securely stored and readily accessible across app sessions.

## Installation

To install Inventix on your iOS device, follow these steps:

1. Clone the repository to your local machine:

   ```bash
   https://github.com/DatTriTat/Inventix.git
   ```

2. Open the project in Xcode.

3. Build and run the project on your iOS device or simulator.

# Inventix Spring Boot Backend

The Inventix Spring Boot backend provides a robust API for the Inventix iOS app. It helps small business owners manage their inventory items and data by offering CRUD operations (Create, Read, Update, Delete) via RESTful endpoints.

## Features

- **RESTful API**: Exposes a set of HTTP endpoints for managing inventory data.
  
- **CRUD Operations**: Supports adding, editing, deleting, and viewing inventory items.
  
- **Data Persistence**: Utilizes a database (via Spring Data JPA) to securely store and retrieve inventory information.
  
- **Categorization**: Allows items to be categorized for better organization.

## Requirements

- Java 17+ (or the required Java version mentioned in the project)
- Maven 

## Contact Us
If you have any questions or find any issues, you can pull request. We'll gladly accept any bug reports.

## Installation

Running All 5 Microservices. The Inventix backend requires 5 services to run for full functionality. Each service is a Spring Boot application with its own Makefile commands to simplify building and running.

1. Build the Application
To compile and package the Spring Boot application, run:    ```make build```

2. Run the Application
After building, start the application using the following command: ```make run```

3. Clean the Project
To clean up the compiled files, run: ```make clean```





