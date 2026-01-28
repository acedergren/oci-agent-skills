module.exports = {
  types: [
    { type: 'feat', section: 'Features' },
    { type: 'fix', section: 'Bug Fixes' },
    { type: 'perf', section: 'Performance Improvements' },
    { type: 'refactor', section: 'Code Refactoring' },
    { type: 'docs', section: 'Documentation' },
    { type: 'revert', section: 'Reverts' },
    { type: 'style', section: 'Styles', hidden: true },
    { type: 'chore', section: 'Maintenance', hidden: true },
    { type: 'test', section: 'Tests', hidden: true },
    { type: 'build', section: 'Build System', hidden: true },
    { type: 'ci', section: 'CI/CD', hidden: true },
  ],
  commitUrlFormat: 'https://github.com/acedergren/oci-agent-skills/commit/{{hash}}',
  compareUrlFormat: 'https://github.com/acedergren/oci-agent-skills/compare/{{previousTag}}...{{currentTag}}',
  issueUrlFormat: 'https://github.com/acedergren/oci-agent-skills/issues/{{id}}',
  userUrlFormat: 'https://github.com/{{user}}',
  releaseCommitMessageFormat: 'chore(release): {{currentTag}}',

  // Skip modifying CHANGELOG.md since we maintain it manually in Keep a Changelog format
  // standard-version will still create git tags and update package.json version
  skip: {
    changelog: true,
  },
};
