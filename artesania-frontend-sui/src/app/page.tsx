/// src/app/page.tsx (CORRECCIÓN CRÍTICA)
"use client"; // <--- AGREGAR ESTA LÍNEA

import { ConnectButton } from "@mysten/dapp-kit";
import { CompraManilla } from "../components/compraManilla";

export default function HomePage() {
  return (
    <main className="container mx-auto p-4 flex flex-col items-center">
      <div className="mb-8 p-4 bg-indigo-100 rounded-lg shadow-md text-center">
        <h1 className="text-3xl font-extrabold text-indigo-900 mb-4">
          Artesanía SUI Devnet
        </h1>

        {/* Botón de conexión de Dapp Kit */}
        <ConnectButton
          connectText="Conectar Billetera Sui"
          className="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded transition duration-200"
        />
      </div>

      <CompraManilla />
    </main>
  );
}
