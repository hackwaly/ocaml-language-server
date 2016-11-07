(* Language Server Protocol Types *)

type request_message = {
  jsonrpc: string;
  id: int; (* or string? *)
  method_: string [@key "method"];
  params: Yojson.Safe.json;
} [@@deriving yojson]

type error = {
  code: int;
  message: string;
  data: Yojson.Safe.json option;
} [@@deriving yojson]

type response_message = {
  jsonrpc: string;
  id: string;
  result: Yojson.Safe.json option;
  error: error option;
} [@@deriving yojson]

(* Basic JSON Structures *)

type position = {
  line: int;
  character: int;
} [@@deriving yojson]

type range = {
  start: position;
  end_: position [@key "end"];
} [@@deriving yojson]

type location = {
  uri: string;
  range: range;
} [@@deriving yojson]

module DiagnosticSeverity = struct
  let error = 1
  let warning = 2
  let information = 3
  let hint = 4
end

type diagnostic = {
  range: range;
  severity: int option;
  code: int option;
  source: string option;
  message: string;
} [@@deriving yojson]

type command = {
  title: string;
  command: string;
  arguments: Yojson.Safe.json;
} [@@deriving yojson]

type text_edit = {
  range: range;
  newText: string;
} [@@deriving yojson]

type workspace_edit = {
  changes: Yojson.Safe.json;
} [@@deriving yojson]

type text_document_identifier = {
  uri: string;
} [@@deriving yojson]

type text_document_item = {
  uri: string;
  languageId: string;
  version: int;
  text: string;
} [@@deriving yojson]

type versioned_text_document_identifier = {
  uri: string;
  version: int;
} [@@deriving yojson]

type text_document_position_params = {
  textDocument: text_document_identifier;
  position: position;
} [@@deriving yojson]

(* Actual Protocol *)

type initialize_params = {
  processId: int option;
  rootPath: string option;
  initializationOptions: Yojson.Safe.json option;
  capabilities: Yojson.Safe.json;
} [@@deriving yojson]

type completion_options = {
  resolveProvider: bool option;
  triggerCharacters: char list option;
} [@@deriving yojson]

type signature_help_options = {
  triggerCharacters: char list option;
} [@@deriving yojson]

type code_lens_options = {
  resolveProvider: bool option;
} [@@deriving yojson]

type document_on_type_formatting_option = {
  firstTriggerCharacter: char;
  moreTriggerCharacter: char list option;
} [@@deriving yojson]

type server_capabilities = {
  textDocumentSync: int option;
  hoverProvider: bool option;
  completionProvider: completion_options option;
  signatureHelpProvider: signature_help_options option;
  definitionProvider: bool option;
  referencesProvider: bool option;
  documentHighlightProvider: bool option;
  documentSymbolProvider: bool option;
  workspaceSymbolProvider: bool option;
  codeActionProvider: bool option;
  codeLensProvider: code_lens_options option;
  documentFormattingProvider: bool option;
  documentRangeFormattingProvider: bool option;
  documentOnTypeFormattingProvider: document_on_type_formatting_option option;
  renameProvider: bool option;
} [@@deriving yojson]

let server_capabilities_none = {
  textDocumentSync = None;
  hoverProvider = None;
  completionProvider = None;
  signatureHelpProvider = None;
  definitionProvider = None;
  referencesProvider = None;
  documentHighlightProvider = None;
  documentSymbolProvider = None;
  workspaceSymbolProvider = None;
  codeActionProvider = None;
  codeLensProvider = None;
  documentFormattingProvider = None;
  documentRangeFormattingProvider = None;
  documentOnTypeFormattingProvider = None;
  renameProvider = None;
}

type initialize_result = {
  capabilities: server_capabilities;
} [@@deriving yojson]

module MessageType = struct
  let error = 1
  let warning = 2
  let info = 3
  let log = 4
end

type show_message_params = {
  type_: int [@key "type"];
  message: string;
} [@@deriving yojson]

type message_action_item = {
  title: string;
} [@@deriving yojson]

type show_message_request_params = {
  type_: int [@key "type"];
  message: string;
  actions: message_action_item list option;
} [@@deriving yojson]

type log_message_params = {
  type_: int [@key "type"];
  message: string;
} [@@deriving yojson]

type did_change_configuration_params = {
  settings: Yojson.Safe.json;
} [@@deriving yojson]

type did_open_text_document_params = {
  textDocument: text_document_item;
} [@@deriving yojson]

type text_document_content_change_event = {
  range: range option;
  rangeLength: int option;
  text: string;
} [@@deriving yojson]

type did_change_text_document_params = {
  textDocument: versioned_text_document_identifier;
  contentChanges: text_document_content_change_event list;
} [@@deriving yojson]

type did_close_text_document_params = {
  textDocument: text_document_identifier;
} [@@deriving yojson]

type did_save_text_document_params = {
  textDocument: text_document_identifier;
} [@@deriving yojson]

module FileChangeType = struct
  let created = 1
  let changed = 2
  let deleted = 3
end

type file_event = {
  uri: string;
  type_: int [@key "type"];
} [@@deriving yojson]

type did_change_watched_files_params = {
  changes: file_event list;
} [@@deriving yojson]

type publish_diagnostics_params = {
  uri: string;
  diagnostics: diagnostic list;
} [@@deriving yojson]

type completion_item = {
  label: string;
  kind: int option;
  detail: string option;
  documentation: string option;
  sortText: string option;
  insertText: string option;
  textEdit: text_edit option;
  additionalTextEdits: text_edit list option;
  command: command option;
  data: Yojson.Safe.json option;
} [@@deriving yojson]

module CompletionItemKind = struct
  let text = 1
  let method_ = 2
  let function_ = 3
  let constructor = 4
  let field = 5
  let variable = 6
  let class_ = 7
  let interface = 8
  let module_ = 9
  let property = 10
  let unit_ = 11
  let value = 12
  let enum = 13
  let keyword = 14
  let snippet = 15
  let color = 16
  let file = 17
  let reference = 18
end

type completion_list = {
  isIncomplete: bool;
  items: completion_item list;
} [@@deriving yojson]

type hover = {
  contents: Yojson.Safe.json;
  range: range option;
} [@@deriving yojson]

type parameter_information = {
  label: string;
  documentation: string option;
} [@@deriving yojson]

type signature_information = {
  label: string;
  documentation: string option;
  parameters: parameter_information list option;
} [@@deriving yojson]

type signature_help = {
  signatures: signature_information;
  activeSignature: int option;
  activeParameter: int option;
} [@@deriving yojson]

type reference_context = {
  includeDeclaration: bool;
} [@@deriving yojson]

type reference_params = {
  textDocument: text_document_identifier;
  position: position;
  context: reference_context;
} [@@deriving yojson]

module DocumentHighlightKind = struct
  let text = 1
  let read = 2
  let write = 3
end

type document_highlight = {
  range: range;
  kind: int option;
} [@@deriving yojson]

type document_symbol_params = {
  textDocument: text_document_identifier;
} [@@deriving yojson]

type symbol_information = {
  name: string;
  kind: int;
  location: location;
  containerName: string option;
} [@@deriving yojson]

module SymbolKind = struct
  let file = 1
  let module_ = 2
  let namespace = 3
  let package = 4
  let class_ = 5
  let method_ = 6
  let property = 7
  let field = 8
  let constructor = 9
  let enum = 10
  let interface = 11
  let function_ = 12
  let variable = 13
  let constant = 14
  let string_ = 15
  let number = 16
  let boolean = 17
  let array_ = 18
end

type workspace_symbol_params = {
  query: string;
} [@@deriving yojson]

type code_action_context = {
  diagnostics: diagnostic list option;
} [@@deriving yojson]

type code_action_params = {
  textDocument: text_document_identifier;
  range: range;
  context: code_action_context;
} [@@deriving yojson]

type code_lens_params = {
  textDocument: text_document_identifier;
} [@@deriving yojson]

type code_lens = {
  range: range;
  command: command option;
  data: Yojson.Safe.json option;
} [@@deriving yojson]

type formatting_options = {
  tabSize: int;
  insertSpaces: bool;
} [@@deriving yojson]

type document_formatting_params = {
  textDocument: text_document_identifier;
  options: formatting_options;
} [@@deriving yojson]

type document_range_formatting_params = {
  textDocument: text_document_identifier;
  range: range;
  options: formatting_options;
} [@@deriving yojson]

type document_on_type_formatting_params = {
  textDocument: text_document_identifier;
  position: position;
  ch: char;
  options: formatting_options;
} [@@deriving yojson]

type rename_params = {
  textDocument: text_document_identifier;
  position: position;
  newName: string;
} [@@deriving yojson]

type request =
  | CancelRequest of int
  | InitializeRequest of initialize_params
  | ShutdownRequest
  | ExitNotification
  | ShowMessageNotification of show_message_params
  | ShowMessageRequest of show_message_request_params
  | LogMessageNotification of log_message_params
  | TelemetryNotification of Yojson.Safe.json
  | DidChangeConfigurationNotification of did_change_configuration_params
  | DidOpenTextDocumentNotification of did_open_text_document_params
  | DidChangeTextDocumentNotification of did_change_text_document_params
  | DidCloseTextDocumentNotification of did_close_text_document_params
  | DidSaveTextDocumentNotification of did_close_text_document_params
  | DidChangeWatchedFilesNotification of did_change_watched_files_params
  | PublishDiagnosticsNotification of publish_diagnostics_params
  | CompletionRequest of text_document_position_params
  | CompletionItemResolveRequest of completion_item
  | HoverRequest of text_document_position_params
  | SignatureHelpRequest of text_document_position_params
  | GotoDefinitionRequest of text_document_position_params
  | FindReferencesRequest of reference_params
  | DocumentHighlightsRequest of text_document_position_params
  | DocumentSymbolsRequest of document_symbol_params
  | WorkspaceSymbolsRequest of workspace_symbol_params
  | CodeActionRequest of code_action_params
  | CodeLensRequest of code_lens_params
  | CodeLensResolveRequest of code_lens
  | DocumentFormattingRequest of document_formatting_params
  | DocumentRangeFormattingRequest of document_range_formatting_params
  | DocumentOnTypeFormattingRequest of document_on_type_formatting_params
  | RenameRequest of rename_params
