import { metadata } from './layout.js'

import { useTheme } from 'next-themes'
import { Bars4Icon } from '@heroicons/react/24/solid'

import { Page } from '@layeredstack/ui'
import logoDark from '@layeredstack/ui/images/logo_dark.svg'
import logoLight from '@layeredstack/ui/images/logo_light.svg'

export default function Home() {
  const mobileMenuIcon = <Bars4Icon className="h-6 w-6" />

  return (
    <Page
      logoDark={logoDark}
      logoLight={logoLight}
      metadata={metadata}
      mobileMenuIcon={mobileMenuIcon}
      useTheme={useTheme}
      user={{
        initials: 'TG'
      }}
    >
      <h1>Organization settings</h1>
      <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi scelerisque dui at dapibus tincidunt. In eleifend ante sit amet rhoncus cursus. Nullam erat lacus, ultrices vel molestie eu, luctus id enim.</p>
    </Page>
  )
}
