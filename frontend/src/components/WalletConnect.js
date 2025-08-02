import React, { useState } from "react";
import Web3 from "web3";

function WalletConnectComponent() {
  const [account, setAccount] = useState("");

  const connectWallet = async () => {
    if (window.ethereum) {
      try {
        const web3 = new Web3(window.ethereum);
        await window.ethereum.request({ method: "eth_requestAccounts" });
        const accounts = await web3.eth.getAccounts();
        setAccount(accounts[0]);
      } catch (err) {
        alert("Connection rejected or error");
      }
    } else {
      alert("MetaMask not detected. Please install it.");
    }
  };

  return (
    <div>
      <button onClick={connectWallet}>Connect Wallet</button>
      {account && <p>Connected account: {account}</p>}
    </div>
  );
}

export default WalletConnectComponent;
