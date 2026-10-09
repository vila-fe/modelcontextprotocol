import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    exclude: ['**/node_modules/**', '**/dist/**'],
    env: {
      PERPLEXITY_API_KEY: 'test-api-key',
      // Ambient proxy settings would route requests through undici and bypass
      // the mocked global fetch; getProxyUrl() treats empty strings as unset.
      PERPLEXITY_PROXY: '',
      HTTPS_PROXY: '',
      HTTP_PROXY: '',
    },
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      exclude: [
        '**/node_modules/**',
        '**/dist/**',
        '**/*.test.ts',
        '**/*.config.ts',
      ],
    },
  },
})
