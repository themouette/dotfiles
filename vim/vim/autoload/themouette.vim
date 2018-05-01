""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                              "
"               Define some frontend related functions                         "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find local executable for a node_module.
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Returng: {string} the fullpath to the command
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

    return ""
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether a module command exists or not in current project's
" node_modules
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Returng: {boolean}
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
" Returng: {string} the fullpath to the command
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
" Returng: {boolean}
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
" Returng: {string}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#GandiProjectsRegExp()
    return "*/Projects/gandi/*";
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether current buffer path is in a Gandi project
"
" Arguments: N/A
"
" Returng: {boolean}
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
" Returng: {string}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#CaliopenProjectsRegExp()
    return "*/Projects/caliopen/*";
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether current buffer path is in a Caliopen project
"
" Arguments: N/A
"
" Returng: {boolean}
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
" Returng: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#IsGandiOrCaliopenProject()
    return themouette#IsGandiProject() || themouette#IsCaliopenProject()
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns the regexp (for aucmd) of DataDog projects
"
" Arguments: N/A
"
" Returng: {string}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#DataDogProjectsRegExp()
    return "*/go/src/github.com/DataDog/*";
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether current buffer path is in a DataDog project
"
" Arguments: N/A
"
" Returng: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! themouette#IsDataDogProject()
    if matchstr(expand('%:p'), "go\/src\/github.com\/DataDog\/") == 'go/src/github.com/DataDog/'
        return 1
    else
        return 0
    endif
endfunction
