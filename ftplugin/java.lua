local jdtls = require('jdtls')

local home = os.getenv("USERPROFILE")
local workspace_folder = home .. "\\.jdtls-workspace\\" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local root_dir = require("jdtls.setup").find_root({".git", "mvnw", "gradlew", "pom.xml", "build.gradle"})

if root_dir then
  jdtls.start_or_attach({
    cmd = {
      vim.fn.stdpath("data") .. "\\mason\\packages\\jdtls\\bin\\jdtls.bat",
      "-data", workspace_folder,
    },
    root_dir = root_dir,
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = "JavaSE-21",
              path = "C:\\Program Files\\Java\\jdk-21", -- adjust if needed
            },
          },
        },
      },
    },
  })
end
