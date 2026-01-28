module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // New feature
        'fix',      // Bug fix
        'docs',     // Documentation
        'style',    // Formatting
        'refactor', // Code restructure
        'perf',     // Performance
        'test',     // Tests
        'chore',    // Maintenance
        'ci',       // CI changes
        'build',    // Build system
        'revert',   // Revert commit
      ],
    ],
    'subject-case': [2, 'never', ['start-case', 'pascal-case', 'upper-case']],
    'subject-max-length': [2, 'always', 100],
    'body-max-line-length': [0, 'always', Infinity],
  },
};
