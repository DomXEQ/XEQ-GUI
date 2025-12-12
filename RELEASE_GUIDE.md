# Release Guide

This guide explains how to create releases for Windows and Linux.

## Option 1: Automated Releases (Recommended)

Using GitHub Actions, releases are automatically built when you create a version tag.

### Steps:

1. **Update version in `package.json`**:

   ```json
   {
     "version": "1.0.0"
   }
   ```

2. **Commit and push the version change**:

   ```bash
   git add package.json
   git commit -m "Bump version to 1.0.0"
   git push origin main
   ```

3. **Create and push a version tag**:

   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

4. **GitHub Actions will automatically**:

   - Build Windows executables (.exe files)
   - Build Linux packages (AppImage and .deb)
   - Create a GitHub release
   - Upload all build artifacts

5. **Check the release**:
   - Go to: https://github.com/DomXEQ/XEQ-GUI/releases
   - The release will appear with all downloadable files

## Option 2: Manual Build and Release

If you want to build locally and upload manually:

### Building on Windows

1. **Install dependencies** (if not already done):

   ```bash
   npm install
   ```

2. **Build Windows executables**:

   ```bash
   npm run build:win
   ```

3. **Find the built files** in `dist/electron/`:
   - `equilibria-electron-wallet-{version}-win.exe` (installer)
   - `equilibria-electron-wallet-{version}-portable.exe` (portable)

### Building on Linux

1. **Install dependencies**:

   ```bash
   npm install
   ```

2. **Install system dependencies**:

   ```bash
   sudo apt-get update
   sudo apt-get install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libuuid1 libsecret-1-0 libappindicator3-1
   ```

3. **Build Linux packages**:

   ```bash
   npm run build:linux
   ```

4. **Find the built files** in `dist/electron/`:
   - `equilibria-electron-wallet-{version}-linux.AppImage`
   - `equilibria-electron-wallet-{version}-linux.deb`

### Creating a Manual GitHub Release

1. **Go to GitHub Releases**:

   - Visit: https://github.com/DomXEQ/XEQ-GUI/releases
   - Click "Draft a new release"

2. **Fill in release details**:

   - **Tag version**: Enter `v1.0.0` (must start with `v`)
   - **Release title**: "Equilibria Electron GUI Wallet 1.0.0"
   - **Description**: Add release notes (see template below)

3. **Upload build artifacts**:

   - Drag and drop all `.exe` files (Windows)
   - Drag and drop `.AppImage` and `.deb` files (Linux)

4. **Publish the release**:
   - Click "Publish release"

### Release Notes Template

```markdown
## Equilibria Electron GUI Wallet 1.0.0

### Downloads

**Windows:**

- Installer: `equilibria-electron-wallet-1.0.0-win.exe`
- Portable: `equilibria-electron-wallet-1.0.0-portable.exe`

**Linux:**

- AppImage: `equilibria-electron-wallet-1.0.0-linux.AppImage`
- Debian Package: `equilibria-electron-wallet-1.0.0-linux.deb`

### Installation Instructions

See the [README.md](https://github.com/DomXEQ/XEQ-GUI/blob/main/README.md) for detailed installation and setup instructions.

### Prerequisites

- Docker Desktop installed and running
- Service Node and Wallet RPC running in Docker (see README for setup)

### Changes in this Release

- [List your changes here]
```

## Important Notes

1. **Builds are platform-specific**:

   - Windows builds can only be created on Windows
   - Linux builds can only be created on Linux
   - That's why automated CI/CD is recommended

2. **Version numbering**:

   - Use semantic versioning: MAJOR.MINOR.PATCH (e.g., 1.0.0)
   - Tag must start with `v` (e.g., `v1.0.0`)

3. **File sizes**:

   - Windows executables are typically 100-200 MB
   - Linux packages are similar in size
   - Make sure you have enough space before building

4. **Testing before release**:
   - Always test the built executables on the target platform
   - Verify Docker integration works correctly
   - Test wallet creation, sending, and receiving

## Troubleshooting

### Build fails with "bin directory not found"

Create the bin directory:

```bash
mkdir -p bin
touch bin/.gitkeep  # Linux/Mac
# or
echo. > bin\.gitkeep  # Windows
```

### Build fails with missing dependencies

Make sure all system dependencies are installed (see Linux build instructions above).

### GitHub Actions build fails

Check the Actions tab on GitHub for detailed error logs. Common issues:

- Missing system dependencies
- Node.js version mismatch
- Missing bin directory
