#lang brag

@ps-program : ps-line-end* body ps-line-end* 
@ps-statement : ps-assignment | ps-display | ps-input
                | ps-if | ps-if-else
                | ps-loop | ps-list-op
                | ps-proc-def | ps-return | ps-proc-call
                | ps-dir

@body : ps-line-end* ([ps-statement ps-line-end+]* ps-statement)? ps-line-end*

@ps-line-end: /COMMENT | /NEWLINE

ps-assignment : ps-id-like /ASSIGN ps-expr
ps-display : /DISPLAY /L-PAREN ps-expr /R-PAREN
ps-input : /INPUT /L-PAREN /R-PAREN

ps-if : /IF /L-PAREN ps-expr /R-PAREN brace-body

ps-if-else : ps-if /ELSE brace-body

@ps-loop : ps-repeat | ps-repeat-until | ps-for-each

ps-repeat : /REPEAT ps-expr /TIMES brace-body

ps-repeat-until: /REPEAT /UNTIL /L-PAREN ps-expr /R-PAREN brace-body

ps-for-each : /FOR /EACH ID /IN ps-expr brace-body

@brace-body: ps-line-end? /L-BRACE ps-line-end? body /R-BRACE ps-line-end?

ps-proc-def : /PROCEDURE ID /L-PAREN ([ID (/COMMA ID)*]) /R-PAREN /NEWLINE* L-BRACE body /R-BRACE

ps-proc-call : ID /L-PAREN [ps-expr (/COMMA ps-expr)*] /R-PAREN

ps-dir: /DIR

ps-return : /RETURN /L-PAREN ps-expr /R-PAREN

@ps-list-op : ps-insert | ps-append | ps-remove

ps-insert : /INSERT /L-PAREN ps-expr /COMMA ps-expr /COMMA ps-expr /R-PAREN

ps-append : /APPEND /L-PAREN ps-expr /COMMA ps-expr /R-PAREN

ps-remove : /REMOVE /L-PAREN ps-expr /COMMA ps-expr /R-PAREN

@ps-expr : ps-disj | ps-input

@ps-disj : ps-or | ps-conj

ps-or : ps-disj /OR ps-conj

@ps-conj : ps-and | ps-eq-ne

ps-and : ps-conj /AND ps-eq-ne

@ps-eq-ne : ps-eq | ps-ne | ps-rel

ps-eq : ps-eq-ne /EQ ps-rel
ps-ne : ps-eq-ne /NE ps-rel

@ps-rel : ps-gt | ps-lt | ps-ge | ps-le | ps-term 

ps-gt : ps-rel /GT ps-term
ps-lt : ps-rel /LT ps-term
ps-ge : ps-rel /GE ps-term
ps-le : ps-rel /LE ps-term

@ps-term : ps-add | ps-sub | ps-factor

ps-add : ps-term /PLUS ps-factor
ps-sub : ps-term /MINUS ps-factor

@ps-factor : ps-mul | ps-div | ps-mod | ps-unary

ps-mul : ps-factor /MUL ps-unary
ps-div : ps-factor /DIV ps-unary
ps-mod : ps-factor /MOD ps-unary

@ps-unary : ps-neg
      | ps-not
      | ps-length
      | @ps-atom-expr

ps-neg : /MINUS @ps-unary
ps-not : /NOT @ps-unary
ps-length : /LENGTH /L-PAREN ps-expr /R-PAREN

@ps-atom-expr : ps-list | ps-list-ref | ps-number | ps-string | ps-boolean | ps-id | /L-PAREN ps-expr /R-PAREN | ps-proc-call

@ps-number : INTEGER | DECIMAL

@ps-string : STRING

ps-boolean : TRUE | FALSE

@ps-id-like : ps-id | ps-list-ref

ps-list : /L-BRACK [ps-expr (/COMMA ps-expr)*] /R-BRACK

ps-list-ref : ps-id /L-BRACK ps-expr /R-BRACK

@ps-id : ID
