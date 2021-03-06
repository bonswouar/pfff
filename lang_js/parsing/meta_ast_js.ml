(* Yoann Padioleau
 *
 * Copyright (C) 2010 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

(* generated by ocamltarzan: ocamltarzan -choice vof ast_js.ml *)

(* pad: few tweaks because of module limitations in ocamltarzan. *)

open Common
open Ast_js
module M = Meta_ast_generic
module Ast = Ast_js

let _current_precision = ref M.default_precision

module Common2 = struct
let vof_filename v = Ocaml.vof_string v
end

module Type_js = struct
    let vof_jstype x = 
      Ocaml.VTODO ""
end
 
let rec
  vof_info x = 
  if not !_current_precision.M.full_info
  then 
    Ocaml.VDict [
      "line", Ocaml.VInt (PI.line_of_info x);
      "col", Ocaml.VInt (PI.col_of_info x);
    ]
  else 
    Parse_info.vof_info x

and vof_tok v = vof_info v
and vof_wrap _of_a (v1, v2) =
  let v1 = _of_a v1 and v2 = vof_info v2 in Ocaml.VTuple [ v1; v2 ]
and vof_paren _of_a (v1, v2, v3) =
  if !_current_precision.M.token_info then
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in Ocaml.VTuple [ v1; v2; v3 ]
  else _of_a v2
and vof_brace _of_a (v1, v2, v3) =
  if !_current_precision.M.token_info then
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in Ocaml.VTuple [ v1; v2; v3 ]
  else _of_a v2
and vof_bracket _of_a (v1, v2, v3) =
  if !_current_precision.M.token_info then
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in Ocaml.VTuple [ v1; v2; v3 ]
  else _of_a v2
and vof_comma_list _of_a xs = 
  if !_current_precision.M.token_info
  then Ocaml.vof_list (Ocaml.vof_either _of_a vof_tok) xs
  else Ocaml.vof_list _of_a (Ast.uncomma xs)

and vof_sc v = Ocaml.vof_option vof_tok v
  
let vof_name v = vof_wrap Ocaml.vof_string v
  
let rec vof_expr =
  function
  | L v1 -> let v1 = vof_litteral v1 in Ocaml.VSum (("L", [ v1 ]))
  | V v1 -> let v1 = vof_name v1 in Ocaml.VSum (("V", [ v1 ]))
  | This v1 -> let v1 = vof_tok v1 in Ocaml.VSum (("This", [ v1 ]))
  | U ((v1, v2)) ->
      let v1 = vof_wrap vof_unop v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("U", [ v1; v2 ]))
  | B ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap vof_binop v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("B", [ v1; v2; v3 ]))
  | Bracket ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_bracket vof_expr v2
      in Ocaml.VSum (("Bracket", [ v1; v2 ]))
  | Period ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_name v3
      in Ocaml.VSum (("Period", [ v1; v2; v3 ]))
  | Object v1 ->
      let v1 =
        vof_brace
          (vof_comma_list
             (fun (v1, v2, v3) ->
                let v1 = vof_property_name v1
                and v2 = vof_tok v2
                and v3 = vof_expr v3
                in Ocaml.VTuple [ v1; v2; v3 ]))
          v1
      in Ocaml.VSum (("Object", [ v1 ]))
  | Array v1 ->
      let v1 = vof_bracket (vof_comma_list vof_expr) v1
      in Ocaml.VSum (("Array", [ v1 ]))
  | Apply ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_paren (vof_comma_list vof_expr) v2
      in Ocaml.VSum (("Apply", [ v1; v2 ]))
  | Conditional ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      and v4 = vof_tok v4
      and v5 = vof_expr v5
      in Ocaml.VSum (("Conditional", [ v1; v2; v3; v4; v5 ]))
  | Assign ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap vof_assignment_operator v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("Assign", [ v1; v2; v3 ]))
  | Seq ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("Seq", [ v1; v2; v3 ]))
  | Function v1 ->
      let v1 = vof_func_decl v1 in Ocaml.VSum (("Function", [ v1 ]))
  | Extra v1 -> let v1 = vof_extra v1 in Ocaml.VSum (("Extra", [ v1 ]))
  | Paren v1 ->
      let v1 = vof_paren vof_expr v1 in Ocaml.VSum (("Paren", [ v1 ]))
and vof_extra =
  function | DanglingComma -> Ocaml.VSum (("DanglingComma", []))
and vof_litteral =
  function
  | Bool v1 ->
      let v1 = vof_wrap Ocaml.vof_bool v1 in Ocaml.VSum (("Bool", [ v1 ]))
  | Num v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Num", [ v1 ]))
  | String v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("String", [ v1 ]))
  | Regexp v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("Regexp", [ v1 ]))
  | Null v1 -> let v1 = vof_tok v1 in Ocaml.VSum (("Null", [ v1 ]))
  | Undefined -> Ocaml.VSum (("Undefined", []))
and vof_unop =
  function
  | U_new -> Ocaml.VSum (("U_new", []))
  | U_delete -> Ocaml.VSum (("U_delete", []))
  | U_void -> Ocaml.VSum (("U_void", []))
  | U_typeof -> Ocaml.VSum (("U_typeof", []))
  | U_bitnot -> Ocaml.VSum (("U_bitnot", []))
  | U_pre_increment -> Ocaml.VSum (("U_pre_increment", []))
  | U_pre_decrement -> Ocaml.VSum (("U_pre_decrement", []))
  | U_post_increment -> Ocaml.VSum (("U_post_increment", []))
  | U_post_decrement -> Ocaml.VSum (("U_post_decrement", []))
  | U_plus -> Ocaml.VSum (("U_plus", []))
  | U_minus -> Ocaml.VSum (("U_minus", []))
  | U_not -> Ocaml.VSum (("U_not", []))
and vof_binop =
  function
  | B_instanceof -> Ocaml.VSum (("B_instanceof", []))
  | B_in -> Ocaml.VSum (("B_in", []))
  | B_mul -> Ocaml.VSum (("B_mul", []))
  | B_div -> Ocaml.VSum (("B_div", []))
  | B_mod -> Ocaml.VSum (("B_mod", []))
  | B_add -> Ocaml.VSum (("B_add", []))
  | B_sub -> Ocaml.VSum (("B_sub", []))
  | B_le -> Ocaml.VSum (("B_le", []))
  | B_ge -> Ocaml.VSum (("B_ge", []))
  | B_lt -> Ocaml.VSum (("B_lt", []))
  | B_gt -> Ocaml.VSum (("B_gt", []))
  | B_lsr -> Ocaml.VSum (("B_lsr", []))
  | B_asr -> Ocaml.VSum (("B_asr", []))
  | B_lsl -> Ocaml.VSum (("B_lsl", []))
  | B_equal -> Ocaml.VSum (("B_equal", []))
  | B_notequal -> Ocaml.VSum (("B_notequal", []))
  | B_physequal -> Ocaml.VSum (("B_physequal", []))
  | B_physnotequal -> Ocaml.VSum (("B_physnotequal", []))
  | B_bitand -> Ocaml.VSum (("B_bitand", []))
  | B_bitor -> Ocaml.VSum (("B_bitor", []))
  | B_bitxor -> Ocaml.VSum (("B_bitxor", []))
  | B_and -> Ocaml.VSum (("B_and", []))
  | B_or -> Ocaml.VSum (("B_or", []))
and vof_property_name =
  function
  | PN_String v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("PN_String", [ v1 ]))
  | PN_Num v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("PN_Num", [ v1 ]))
  | PN_Empty -> Ocaml.VSum (("PN_Empty", []))
and vof_assignment_operator =
  function
  | A_eq -> Ocaml.VSum (("A_eq", []))
  | A_mul -> Ocaml.VSum (("A_mul", []))
  | A_div -> Ocaml.VSum (("A_div", []))
  | A_mod -> Ocaml.VSum (("A_mod", []))
  | A_add -> Ocaml.VSum (("A_add", []))
  | A_sub -> Ocaml.VSum (("A_sub", []))
  | A_lsl -> Ocaml.VSum (("A_lsl", []))
  | A_lsr -> Ocaml.VSum (("A_lsr", []))
  | A_asr -> Ocaml.VSum (("A_asr", []))
  | A_and -> Ocaml.VSum (("A_and", []))
  | A_xor -> Ocaml.VSum (("A_xor", []))
  | A_or -> Ocaml.VSum (("A_or", []))
and vof_st =
  function
  | Variable ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_comma_list vof_variable_declaration v2
      and v3 = vof_sc v3
      in Ocaml.VSum (("Variable", [ v1; v2; v3 ]))
  | Const ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_comma_list vof_variable_declaration v2
      and v3 = vof_sc v3
      in Ocaml.VSum (("Const", [ v1; v2; v3 ]))
  | Block v1 ->
      let v1 = vof_brace (Ocaml.vof_list vof_toplevel) v1
      in Ocaml.VSum (("Block", [ v1 ]))
  | Nop v1 -> let v1 = vof_sc v1 in Ocaml.VSum (("Nop", [ v1 ]))
  | ExprStmt ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_sc v2
      in Ocaml.VSum (("ExprStmt", [ v1; v2 ]))
  | If ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_paren vof_expr v2
      and v3 = vof_st v3
      and v4 =
        Ocaml.vof_option
          (fun (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_st v2
             in Ocaml.VTuple [ v1; v2 ])
          v4
      in Ocaml.VSum (("If", [ v1; v2; v3; v4 ]))
  | Do ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_tok v1
      and v2 = vof_st v2
      and v3 = vof_tok v3
      and v4 = vof_paren vof_expr v4
      and v5 = vof_sc v5
      in Ocaml.VSum (("Do", [ v1; v2; v3; v4; v5 ]))
  | While ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_paren vof_expr v2
      and v3 = vof_st v3
      in Ocaml.VSum (("While", [ v1; v2; v3 ]))
  | For ((v1, v2, v3, v4, v5, v6, v7, v8, v9)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = Ocaml.vof_option vof_lhs_or_var v3
      and v4 = vof_tok v4
      and v5 = Ocaml.vof_option vof_expr v5
      and v6 = vof_tok v6
      and v7 = Ocaml.vof_option vof_expr v7
      and v8 = vof_tok v8
      and v9 = vof_st v9
      in Ocaml.VSum (("For", [ v1; v2; v3; v4; v5; v6; v7; v8; v9 ]))
  | ForIn ((v1, v2, v3, v4, v5, v6, v7)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = vof_lhs_or_var v3
      and v4 = vof_tok v4
      and v5 = vof_expr v5
      and v6 = vof_tok v6
      and v7 = vof_st v7
      in Ocaml.VSum (("ForIn", [ v1; v2; v3; v4; v5; v6; v7 ]))
  | Switch ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_paren vof_expr v2
      and v3 = vof_brace (Ocaml.vof_list vof_case_clause) v3
      in Ocaml.VSum (("Switch", [ v1; v2; v3 ]))
  | Continue ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = Ocaml.vof_option vof_label v2
      and v3 = vof_sc v3
      in Ocaml.VSum (("Continue", [ v1; v2; v3 ]))
  | Break ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = Ocaml.vof_option vof_label v2
      and v3 = vof_sc v3
      in Ocaml.VSum (("Break", [ v1; v2; v3 ]))
  | Return ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = Ocaml.vof_option vof_expr v2
      and v3 = vof_sc v3
      in Ocaml.VSum (("Return", [ v1; v2; v3 ]))
  | With ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_paren vof_expr v2
      and v3 = vof_st v3
      in Ocaml.VSum (("With", [ v1; v2; v3 ]))
  | Labeled ((v1, v2, v3)) ->
      let v1 = vof_label v1
      and v2 = vof_tok v2
      and v3 = vof_st v3
      in Ocaml.VSum (("Labeled", [ v1; v2; v3 ]))
  | Throw ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      and v3 = vof_sc v3
      in Ocaml.VSum (("Throw", [ v1; v2; v3 ]))
  | Try ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_st v2
      and v3 =
        Ocaml.vof_option
          (fun (v1, v2, v3) ->
             let v1 = vof_tok v1
             and v2 = vof_paren vof_arg v2
             and v3 = vof_st v3
             in Ocaml.VTuple [ v1; v2; v3 ])
          v3
      and v4 =
        Ocaml.vof_option
          (fun (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_st v2
             in Ocaml.VTuple [ v1; v2 ])
          v4
      in Ocaml.VSum (("Try", [ v1; v2; v3; v4 ]))
and vof_label v = vof_wrap Ocaml.vof_string v
and vof_lhs_or_var =
  function
  | LHS v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("LHS", [ v1 ]))
  | Vars ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_comma_list vof_variable_declaration v2
      in Ocaml.VSum (("Vars", [ v1; v2 ]))
and vof_case_clause =
  function
  | Default ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = Ocaml.vof_list vof_toplevel v3
      in Ocaml.VSum (("Default", [ v1; v2; v3 ]))
  | Case ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      and v3 = vof_tok v3
      and v4 = Ocaml.vof_list vof_toplevel v4
      in Ocaml.VSum (("Case", [ v1; v2; v3; v4 ]))
and vof_arg v = vof_wrap Ocaml.vof_string v
and vof_func_decl (v1, v2, v3, v4) =
  let v1 = vof_tok v1
  and v2 = Ocaml.vof_option vof_name v2
  and v3 = vof_paren (vof_comma_list vof_name) v3
  and v4 = vof_brace (Ocaml.vof_list vof_toplevel) v4
  in Ocaml.VTuple [ v1; v2; v3; v4 ]
and vof_variable_declaration (v1, v2) =
  let v1 = vof_name v1
  and v2 =
    Ocaml.vof_option
      (fun (v1, v2) ->
         let v1 = vof_tok v1 and v2 = vof_expr v2 in Ocaml.VTuple [ v1; v2 ])
      v2
  in Ocaml.VTuple [ v1; v2 ]
and vof_toplevel =
  function
  | St v1 -> let v1 = vof_st v1 in Ocaml.VSum (("St", [ v1 ]))
  | FunDecl v1 ->
      let v1 = vof_func_decl v1 in Ocaml.VSum (("FunDecl", [ v1 ]))
  | NotParsedCorrectly v1 ->
      let v1 = Ocaml.vof_list vof_info v1
      in Ocaml.VSum (("NotParsedCorrectly", [ v1 ]))
  | FinalDef v1 -> let v1 = vof_info v1 in Ocaml.VSum (("FinalDef", [ v1 ]))
and vof_program_orig v = Ocaml.vof_list vof_toplevel v

(* end auto generation *)

let vof_program precision x = 
  Common.save_excursion _current_precision precision (fun () ->
    vof_program_orig x
  )
