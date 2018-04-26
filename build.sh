lex project.l
yacc -d project.y
gcc lex.yy.c y.tab.c -ll -ly
echo "Please enter the testfile number!"
read number
./a.out < input$number.java
cd AST
lex ast.l
yacc -d -v ast.y
gcc lex.yy.c y.tab.c graph.c -ll -ly -o ast.out
echo 
echo
echo "************************Abstract Syntax Tree**************************"
./ast.out < input$number.java
