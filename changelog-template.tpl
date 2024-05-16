{{- $CurrentRevision := .CurrentRevision -}}
{{- $PreviousRevision := .PreviousRevision -}}

{{with .NotesWithActionRequired -}}
## Urgent Upgrade Notes 

### (No, really, you MUST read this before you upgrade)

{{range .}}{{println "-" .}} {{end}}
{{end}}

{{- if .Notes -}}
{{- range $notes := .Notes -}}
{{range $note := .NoteEntries}}
* [{{- $notes.Kind }}] {{$note}}
{{- end -}}
{{- end -}}
{{- end -}}
