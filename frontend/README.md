# Vietnam National Hospital Dashboard Frontend

This is the frontend for the Vietnam National Hospital Dashboard application. It provides a user-friendly interface for viewing and managing hospital data, including facilities, departments, doctors, patients, medical records, and appointments.

## Features

- Dashboard with key metrics and visualizations
- Facility and department management
- Doctor and patient directory
- Appointment scheduling and tracking
- Medical records management
- Distributed system visualization
- Responsive design for desktop and mobile

## Technology Stack

- React (JavaScript library for building user interfaces)
- Material-UI (React component library)
- Recharts (Charting library for React)
- Axios (HTTP client)
- React Router (Navigation)

## Development Setup

The easiest way to run the frontend is to use the provided `run.sh` script from the root directory:

```bash
./run.sh
```

This will:
1. Install dependencies
2. Start the backend server
3. Start the frontend development server
4. Open the application in your default browser

### Manual Setup

If you prefer to set up the frontend manually:

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

4. Open your browser and navigate to `http://localhost:3000`

## Building for Production

To create a production build:

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Build the application:
   ```bash
   npm run build
   ```

3. The build artifacts will be stored in the `build/` directory

## Project Structure

```
frontend/
├── public/          # Public assets
├── src/             # Source code
│   ├── components/  # Reusable components
│   │   └── layouts/ # Layout components
│   ├── pages/       # Page components
│   ├── services/    # API services
│   ├── App.js       # Root component
│   └── index.js     # Entry point
└── package.json     # Dependencies and scripts
```

## Available Scripts

- `npm start` - Starts the development server
- `npm run build` - Builds the app for production
- `npm test` - Runs the test watcher
- `npm run eject` - Ejects from create-react-app

## Connecting to the Backend

The frontend connects to the backend API running on `http://localhost:5000`. If you need to change this URL, you can modify it in the `src/services/api.js` file.

## Customization

You can customize the frontend by:

- Modifying the color theme in `src/App.js`
- Adding new pages in the `src/pages` directory
- Updating the navigation in `src/components/layouts/MainLayout.js`
- Adding new API endpoints in `src/services/api.js`

## Troubleshooting

- **API Connection Issues**: Make sure the backend server is running and accessible.
- **Missing Dependencies**: Run `npm install` to install all required dependencies.
- **Build Errors**: Check the console for specific error messages.
- **Layout Issues**: The application is designed to be responsive, but you might need to adjust some components for specific screen sizes. 