/**
 * This file is used specifically and only for development. It installs
 * `electron-debug` & `vue-devtools`. There shouldn"t be any need to
 *  modify this file, but it can be used to extend your development
 *  environment.
 */

// Remove NODE_OPTIONS before Electron starts (must be first thing)
if (
  process.env.NODE_OPTIONS &&
  process.env.NODE_OPTIONS.includes("--openssl-legacy-provider")
) {
  delete process.env.NODE_OPTIONS;
}

// Install `electron-debug` with `devtron`
require("electron-debug")({
  showDevTools: false
});

// Install `vue-devtools` (optional - disabled for now due to installation issues)
// You can manually install it later if needed
require("electron").app.on("ready", () => {
  // Temporarily disabled - uncomment if you want to try installing vue-devtools
  /*
  try {
    let installExtension = require("electron-devtools-installer");
    installExtension
      .default(installExtension.VUEJS_DEVTOOLS)
      .then(() => {
        console.log("Vue DevTools installed successfully");
      })
      .catch(err => {
        console.log("Unable to install `vue-devtools` (this is optional):", err.message);
      });
  } catch (err) {
    console.log("Vue DevTools installer not available (this is optional):", err.message);
  }
  */
  console.log("Vue DevTools installation skipped (optional dev tool)");
});

// Require `main` process to boot app
require("./electron-main");
