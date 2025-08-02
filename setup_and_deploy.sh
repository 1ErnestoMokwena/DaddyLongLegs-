#!/bin/bash

echo "🚀 Installing backend dependencies and deploying contracts..."
cd backend
npm install
npx hardhat run scripts/deploy.js --network sepolia

echo "✅ Backend deployment complete."

echo "🚀 Installing frontend dependencies and building React app..."
cd ../frontend
npm install
npm run build

echo "✅ Frontend build complete."

echo "🎉 All done! You can now push the frontend folder to GitHub and deploy it on Vercel."
