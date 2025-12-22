/// src/components/CompraManilla.tsx (FINAL CORREGIDO)
"use client";
import {
  useSignAndExecuteTransaction,
  useCurrentAccount,
} from "@mysten/dapp-kit"; // <-- Corregido: 'Transaction'
import { Transaction } from "@mysten/sui/transactions"; // <-- Importación antigua de respaldo // <-- Corregido: Importación directa
import { bcs } from "@mysten/sui/bcs";
import {
  PACKAGE_ID,
  SHOP_ID,
  MODULE_NAME,
  FUNCTION_NAME,
  PRICE,
} from "../lib/sui_config";

export function CompraManilla() {
  // Corregido el nombre del hook a useSignAndExecuteTransaction
  const { mutate: signAndExecuteTransaction, isPending } =
    useSignAndExecuteTransaction();
  const account = useCurrentAccount();
  const isConnected = !!account;

  const handleBuy = () => {
    if (!isConnected) {
      alert("Por favor, conecta tu billetera primero.");
      return;
    }

    const txb = new Transaction();

    // 1. Crear una moneda de pago (1 SUI)
    const [coin] = txb.splitCoins(txb.gas, [txb.pure("u64", PRICE)]);
    // 2. Llamada a la función Move
    txb.moveCall({
      target: `${PACKAGE_ID}::${MODULE_NAME}::${FUNCTION_NAME}`,
      arguments: [
        txb.object(SHOP_ID),
        coin,
        txb.pure("string", "Plata Y cuero"),
      ],
    });

    // Ejecución de la transacción con el hook renombrado
    signAndExecuteTransaction(
      { transaction: txb },
      {
        onSuccess: (response) => {
          alert(`Compra Exitosa! Digest: ${response.digest}`);
          console.log("Transacción exitosa:", response);
        },
        onError: (error) => {
          alert("Error en la transacción. Revisa la consola.");
          console.error("Error de transacción:", error);
        },
      }
    );
  };

  return (
    <div className="flex flex-col items-center p-6 bg-white shadow-lg rounded-xl max-w-sm mx-auto mt-10">
      <h3 className="text-2xl font-bold text-indigo-700 mb-4">
        Manilla: Plata Y cuero
      </h3>
      <p className="text-xl text-gray-800 mb-6">Precio: 1 SUI</p>

      <button
        onClick={handleBuy}
        disabled={isPending || !isConnected}
        className={`w-full py-3 rounded-lg font-semibold transition duration-200 ${
          isPending || !isConnected
            ? "bg-gray-400 text-gray-700 cursor-not-allowed"
            : "bg-green-500 hover:bg-green-600 text-white"
        }`}
      >
        {isPending
          ? "Procesando..."
          : isConnected
          ? "Comprar Manilla"
          : "Conecta para Comprar"}
      </button>
    </div>
  );
}
