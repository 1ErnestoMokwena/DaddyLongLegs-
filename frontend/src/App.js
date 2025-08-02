import React from "react";
import WalletConnectComponent from "./components/WalletConnect";

function App() {
  return (
    <div style={{ padding: 20, fontFamily: "Arial" }}>
      <h1>DaddyLongLegs ($DLL) Decentralized App</h1>
      <WalletConnectComponent />
      {/* Additional UI components like tokenomics dashboard, DAO, etc. go here */}
    </div>
  );
}

export default App;
