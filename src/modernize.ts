import { Octokit } from '@octokit/rest';
import simpleGit from 'simple-git';
import * as fs from 'fs';

// Placeholder: List of target repositories to modernize
const TARGET_REPOS: string[] = [
    'ViniciusSouza/spring-boot-rest-example',
];

import path from 'path';
const rulesPath = path.resolve(__dirname, '../semgrep-rules');

// Run semgrep for static code analysis and create issues for the code agent
import { exec } from 'child_process';
import util from 'util';
const execAsync = util.promisify(exec);

async function runSemgrep(localPath: string): Promise<any[]> {
  try {
    const { stdout } = await execAsync(
      `semgrep --config ${rulesPath}  --json`,
      { cwd: localPath, maxBuffer: 10 * 1024 * 1024 }
    );
    const result = JSON.parse(stdout);
    return result.results || [];
  } catch (err) {
    console.error('Semgrep failed:', err);
    return [];
  }
}

async function createIssuesFromFindings(octokit: any, owner: string, repo: string, findings: any[]) {
  for (const finding of findings) {
    const title = `[Semgrep] ${finding.check_id || 'Issue'} in ${finding.path}`;
    const body = `**Rule:** ${finding.check_id}\n**Path:** ${finding.path}\n**Start Line:** ${finding.start.line}\n**Message:** ${finding.extra?.message || ''}\n\n**Code:**\n\n\
 ${finding.extra?.lines || ''}`;
    try {
      await octokit.issues.create({
        owner,
        repo,
        title,
        body,
        labels: ['semgrep', 'code-agent'],
      });
    } catch (e) {
      console.error('Failed to create issue:', e);
    }
  }
}

async function modernizeRepo(localPath: string, octokit: any, owner: string, repo: string) {
  console.log(`Running semgrep on repo at ${localPath} ...`);
  const findings = await runSemgrep(localPath);
  if (findings.length === 0) {
    console.log('No issues found by semgrep.');
    return;
  }
  console.log(`Found ${findings.length} issues, creating GitHub issues ...`);
  await createIssuesFromFindings(octokit, owner, repo, findings);
}

async function main() {
  const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });
  for (const repo of TARGET_REPOS) {
    const [owner, name] = repo.split('/');
    const localPath = `./tmp/${name}`;
    const git = simpleGit();
    // Clone or pull latest
    if (!fs.existsSync(localPath)) {
      await git.clone(`https://github.com/${repo}.git`, localPath);
    } else {
      await git.cwd(localPath).pull();
    }
  // Run semgrep and create issues
  await modernizeRepo(localPath, octokit, owner, name);
    // TODO: Commit and push changes, open PR using Octokit
  }
}

main().catch(console.error);
