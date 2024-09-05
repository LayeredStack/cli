import { ThemeProvider } from 'next-themes'

import '@layeredstack/ui/styles/ls_ui.css'

export const metadata = {
  initials: 'LS',
  title: 'Layered Stack - UI (Example)',
  description: 'Example of the Layered Stack - UI interface components',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <ThemeProvider attribute='class'>
          {children}
        </ThemeProvider>
      </body>
    </html>
  )
}
