""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                              "
"               Define some frontend related functions                         "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! themouette#UseYarnV2()
    let yarn_path = finddir('.yarn', '.;')
    return strlen(yarn_path)
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether a node module is locally installed or not
"
" Arguments
" * module_name: the module to look for (i.e. 'express', 'react'...)
"
" Return: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#HasLocalNodeModule(module_name)
    " Yarn 2 does not use `node_modules`, we need to leverage package.json
    if themouette#UseYarnV2()
        let package_json = findfile('package.json', '.;')
        if empty(package_json)
            return 0
        endif
        return filereadable(package_json) && match(readfile(package_json),'"'. a:module_name .'"')
    endif

    let module_name = finddir('node_modules', '.;') . '/' . a:module_name

    " make sure this is an absolute path
    if matchstr(module_name, "^\/\\w") == ''
        let module_name = getcwd() . "/" . module_name
    endif

    return isdirectory(module_name)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find local executable for a node_module.
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Return: {string} the fullpath to the command
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#FindLocalNodeModulesExec(module_cmd)
    let cmd_path = finddir('node_modules', '.;') . '/.bin/' . a:module_cmd

    " make sure this is an absolute path
    if matchstr(cmd_path, "^\/\\w") == ''
        let cmd_path = getcwd() . "/" . cmd_path
    endif
    " check it is executable
    if executable(cmd_path)
        return cmd_path
    endif

    " yarn 2 does not expose all the executable in `node_modules` anymore.
    " Let's leverage the `.vscode` pnpify config.
    let cmd_path = finddir('.yarn', '.;') . '/bin/' . a:module_cmd
    " make sure this is an absolute path
    if matchstr(cmd_path, "^\/\\w") == ''
        let cmd_path = getcwd() . "/" . cmd_path
    endif
    " check it is executable
    if executable(cmd_path)
        return cmd_path
    endif

    return ""
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether a module command exists or not in current project's
" node_modules
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Return: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#HasLocalNodeModuleExec(module_cmd)
    return strlen(themouette#FindLocalNodeModulesExec(a:module_cmd)) > 0
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find the best matching executable from a node_module.
" Always prefer local version of the package, and fallback on a global version
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Return: {string} the fullpath to the command
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#FindNodeModulesExec(module_cmd)
    let cmd_path = themouette#FindLocalNodeModulesExec(a:module_cmd)
    " check it is executable
    if strlen(cmd_path)
        return cmd_path
    endif

    " attempt to find a globaly installed npm package matching the request
    if !executable('npm')
        return ""
    endif

    let cmd_path = system('npm bin -g')[:-2] . "/" . a:module_cmd
    " check it is executable
    if executable(cmd_path)
        return cmd_path
    endif

    return ""
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether a module command exists or not
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Return: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#HasNodeModuleExec(module_cmd)
    return strlen(themouette#FindNodeModulesExec(a:module_cmd)) > 0
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                              "
"                      Define projects related functions                       "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns the regexp (for aucmd) of Gandi projects
"
" Arguments: N/A
"
" Return: {string}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#GandiProjectsRegExp()
    return "*/Projects/gandi/*";
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether current buffer path is in a Gandi project
"
" Arguments: N/A
"
" Return: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#IsGandiProject()
    if matchstr(expand('%:p'), "Projects\/gandi\/") == 'Projects/gandi/'
        return 1
    else
        return 0
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns the regexp (for aucmd) of Gandi projects
"
" Arguments: N/A
"
" Return: {string}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#CaliopenProjectsRegExp()
    return "*/Projects/caliopen/*";
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether current buffer path is in a Caliopen project
"
" Arguments: N/A
"
" Return: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#IsCaliopenProject()
    if matchstr(expand('%:p'), "Projects\/caliopen\/") == 'Projects/caliopen/'
        return 1
    else
        return 0
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether current buffer path is in a Caliopen or Gandi
" project
"
" Arguments: N/A
"
" Return: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#IsGandiOrCaliopenProject()
    return themouette#IsGandiProject() || themouette#IsCaliopenProject()
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns the regexp (for aucmd) of DataDog projects
"
" Arguments: N/A
"
" Return: {string}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#DataDogProjectsRegExp()
    return "*/go/src/github.com/DataDog/*";
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether current buffer path is in a DataDog project
"
" Arguments: N/A
"
" Return: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#IsDataDogProject()
    if matchstr(expand('%:p'), "go\/src\/github.com\/DataDog\/") == 'go/src/github.com/DataDog/'
        return 1
    endif
    if matchstr(expand('%:p'), "Projects\/datadog\/") == 'Projects/datadog/'
        return 1
    endif

    return 0
endfunction
