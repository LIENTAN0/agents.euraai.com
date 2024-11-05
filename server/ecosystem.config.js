module.exports = {
  apps: [{
    name: "company-api",
    script: "./index.js",
    env: {
      NODE_ENV: "production",
      PORT: 3000
    },
    instances: 1,
    exec_mode: "fork",
    watch: false,
    max_memory_restart: "1G"
  }]
} 