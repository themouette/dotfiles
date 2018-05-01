" code indent
if themouette#IsDataDogProject()
    setlocal colorcolumn=80
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
elseif themouette#IsGandiOrCaliopenProject()
    setlocal colorcolumn=100
    setlocal tabstop=2 shiftwidth=2 softtabstop=2
    setlocal tabstop=2 shiftwidth=2 softtabstop=2
else
    setlocal colorcolumn=80
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
endif

