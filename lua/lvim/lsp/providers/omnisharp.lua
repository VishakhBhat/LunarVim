local opts = {
    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support  = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers  = true,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = true,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = true,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    analyze_open_documents_only = true,

    -- Provide the function to calculate the root directory to LSP
    root_dir = function(fname)
        -- Todo: Remove the hard code and use current neovim directory
      return 'C:\\Users\\vbhat24\\git\\Strategies\\Middleware'
    end,

    -- Override the on_new_config from LSP to provide the solution name to omnisharp
    on_new_config = function(new_config, new_root_dir)

        -- TODO remove the hard code of solution name, instead read the solution in the new_root_dir
        local solution_name = ''
        local solution_number = vim.fn.input("Enter the solution(number) you want to load:\n1. Reporting\n2. Middleware\n-> ", "", "file")
        if solution_number == "1" then
            solution_name = '/Reporting.sln'
        elseif solution_number == "2" then
            solution_name = '/MiddlewareRelease.sln'
        end
        table.insert(new_config.cmd, '-z') -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
        vim.list_extend(new_config.cmd, { '-s', new_root_dir .. solution_name })
        vim.list_extend(new_config.cmd, { '--hostPID', tostring(vim.fn.getpid()) })
        table.insert(new_config.cmd, 'DotNet:enablePackageRestore=false')
        vim.list_extend(new_config.cmd, { '--encoding', 'utf-8' })
        table.insert(new_config.cmd, '--languageserver')

        if new_config.enable_editorconfig_support then
          table.insert(new_config.cmd, 'FormattingOptions:EnableEditorConfigSupport=true')
        end

        if new_config.organize_imports_on_format then
          table.insert(new_config.cmd, 'FormattingOptions:OrganizeImports=true')
        end

        if new_config.enable_ms_build_load_projects_on_demand then
          table.insert(new_config.cmd, 'MsBuild:LoadProjectsOnDemand=true')
        end

        if new_config.enable_roslyn_analyzers then
          table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableAnalyzersSupport=true')
        end

        if new_config.enable_import_completion then
          table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableImportCompletion=true')
        end

        if new_config.sdk_include_prereleases then
          table.insert(new_config.cmd, 'Sdk:IncludePrereleases=true')
        end

        if new_config.analyze_open_documents_only then
          table.insert(new_config.cmd, 'RoslynExtensionsOptions:AnalyzeOpenDocumentsOnly=true')
        end
      end,
  }

  return opts
