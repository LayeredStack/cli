// Next
import { ThemeProvider, useTheme } from 'next-themes'

// Packages
import { Bars3Icon } from '@heroicons/react/24/solid'
import { Page } from '@layeredstack/ui'

// Logos
import logoDark from './logo_dark.svg'
import logoLight from './logo_light.svg'

// Styles
import '@layeredstack/ui/styles/ls_ui.css'

// Metadata
export const metadata = {
  initials: 'LS',
  title: 'Layered Stack - UI (Example)',
  description: 'Example of the Layered Stack - UI interface components',
}

// Layout
export default function RootLayout({ children }) {
  const mobileMenuIcon = <Bars3Icon className="h-6 w-6" />

  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <ThemeProvider attribute='class'>
          <Page
            backendUrl="http://localhost:3000"
            logoDark={logoDark}
            logoLight={logoLight}
            metadata={metadata}
            // mobileMenuIcon={mobileMenuIcon}
            useTheme={useTheme}
            user={{
              initials: 'TG'
            }}
          >
            {children}
          </Page>
        </ThemeProvider>
      </body>
    </html>
  )
}
