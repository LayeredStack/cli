// Next
import { useTheme } from 'next-themes'

// Packages
import { Bars3Icon } from '@heroicons/react/24/solid'
import { Page } from '@layeredstack/ui'

// Local
import { metadata } from './layout.js'

// Logo
import logoDark from './logo_dark.svg'
import logoLight from './logo_light.svg'

// Home
export default function Home() {
  const mobileMenuIcon = <Bars3Icon className="h-6 w-6" />

  return (
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
      <h1>Hello world!</h1>
      <p>This is a simple page.</p>
    </Page>
  )
}
