param([string]$InputDoc,[string]$OutputPdf)
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
$document = $null
try {
  $document = $word.Documents.Open($InputDoc, $false, $true)
  $document.ExportAsFixedFormat($OutputPdf, 17)
} finally {
  if ($null -ne $document) { $document.Close(0) }
  $word.Quit()
}
