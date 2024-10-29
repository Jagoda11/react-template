module.exports = {
  env: {
    browser: true,
    es2021: true,
    jest: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:jest/recommended',
    'plugin:prettier/recommended',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint', 'jest', 'prettier', 'react-hooks'],
  rules: {
    'prettier/prettier': 'error', // Enforce Prettier formatting
    'react/jsx-filename-extension': [
      1,
      { extensions: ['.tsx'] }, // Enforce the use of .tsx extension for JSX files
    ],
    '@typescript-eslint/explicit-module-boundary-types': 'warn', // Ensure functions have explicit return types
    '@typescript-eslint/no-unused-vars': 'warn', // Warn about unused variables
    '@typescript-eslint/no-explicit-any': 'warn', // Warn about usage of the any type
    'no-console': 'warn',
    'jest/no-disabled-tests': 'warn', // Warn about disabled tests
    'jest/no-focused-tests': 'error', // Error on focused tests
    'jest/no-identical-title': 'error',
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'warn',
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
  ignores: [
    'node_modules/',
    'dist/',
    'package-lock.json',
    '*.min.js',
    'coverage/',
    'build/',
    'public/',
    '*.md',
    '.vscode/',
  ],
}
