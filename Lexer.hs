module Lexer where 

import Data.Char 

data Expr = BTrue
          | BFalse 
          | Num Int 
          | Add Expr Expr 
          | Sub Expr Expr
          | Mul Expr Expr
          | Equal Expr Expr 
          | Great Expr Expr
          | Less Expr Expr
          | And Expr Expr 
          | Or Expr Expr
          | If Expr Expr Expr 
          | Var String
          | Lam String Ty Expr 
          | App Expr Expr
          | Paren Expr
          | Aspa Expr
          | Let String Expr Expr 
          | Concat Expr Expr
          | Str String 
          deriving Show

data Ty = TBool 
        | TNum 
        | TFun Ty Ty
        | TStr
        deriving (Show, Eq)

data Token = TokenTrue 
           | TokenFalse 
           | TokenNum Int 
           | TokenAdd
           | TokenSub
           | TokenMul
           | TokenEqual
           | TokenGreat
           | TokenLess
           | TokenAnd 
           | TokenOr
           | TokenIf 
           | TokenThen 
           | TokenElse
           | TokenVar String 
           | TokenLam
           | TokenArrow
           | TokenLParen
           | TokenRParen
           | TokenAspa
           | TokenLet 
           | TokenEq 
           | TokenIn
           | TokenColon
           | TokenBoolean 
           | TokenNumber
           | TokenString
           | TokenStr String 
           | TokenConcat
           deriving (Show, Eq)

isSymb :: Char -> Bool 
isSymb c = c `elem` "+&\\-><()=:-*|"

lexer :: String -> [Token]
lexer [] = [] 
lexer ('(':cs) = TokenLParen : lexer cs
lexer (')':cs) = TokenRParen : lexer cs
lexer ('\"':cs) = TokenAspa : lexStr cs
lexer (c:cs) | isSpace c = lexer cs 
             | isDigit c = lexNum (c:cs)
             | isSymb c = lexSymbol (c:cs)
             | isAlpha c = lexKW (c:cs)
lexer _ = error "Lexical error!"

lexNum :: String -> [Token]
lexNum cs = case span isDigit cs of 
              (num, rest) -> TokenNum (read num) : lexer rest

lexSymbol :: String -> [Token]
lexSymbol cs = case span isSymb cs of
                 ("+", rest)  -> TokenAdd : lexer rest 
                 ("-", rest)  -> TokenSub : lexer rest 
                 ("*", rest)  -> TokenMul : lexer rest 
                 ("&&", rest) -> TokenAnd : lexer rest 
                 ("\\", rest) -> TokenLam : lexer rest 
                 ("->", rest) -> TokenArrow : lexer rest 
                 ("=", rest)  -> TokenEq : lexer rest 
                 (":", rest)  -> TokenColon : lexer rest 
                 ("==", rest) -> TokenEqual : lexer rest
                 (">", rest) -> TokenGreat : lexer rest
                 ("<", rest) -> TokenLess : lexer rest
                 ("||", rest) -> TokenOr : lexer rest
                 ("++", rest) -> TokenConcat : lexer rest
                 _ -> error "Lexical error: invalid symbol!"


lexStr :: String -> [Token]
lexStr cs = case span (/= '\"') cs of 
              (str, '\"':rest) -> TokenStr str : TokenAspa : lexer rest 
              _ -> error "Lexical error: invalid string!"

lexKW :: String -> [Token]
lexKW cs = case span isAlpha cs of 
             ("true", rest) -> TokenTrue : lexer rest 
             ("false", rest) -> TokenFalse : lexer rest
             ("if", rest) -> TokenIf : lexer rest 
             ("then", rest) -> TokenThen : lexer rest 
             ("else", rest) -> TokenElse : lexer rest 
             ("let", rest) -> TokenLet : lexer rest 
             ("in", rest) -> TokenIn : lexer rest 
             ("Num", rest) -> TokenNumber : lexer rest 
             ("Bool", rest) -> TokenBoolean : lexer rest 
             (var, rest) -> TokenVar var : lexer rest 


