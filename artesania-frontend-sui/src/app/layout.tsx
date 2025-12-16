/// src/app/layout.tsx
"use client";

import { WalletProvider, SuiClientProvider } from "@mysten/dapp-kit";
import { getFullnodeUrl } from "@mysten/sui";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import "./globals.css";

// Configuración de red para Devnet
const networks = {
  devnet: { url: getFullnodeUrl("devnet") },
};

const queryClient = new QueryClient();

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-gray-50 min-h-screen p-8">
        <QueryClientProvider client={queryClient}>
          <SuiClientProvider defaultNetwork="devnet" networks={networks}>
            <WalletProvider>{children}</WalletProvider>
          </SuiClientProvider>
        </QueryClientProvider>
      </body>
    </html>
  );
}
