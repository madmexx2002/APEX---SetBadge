   function CALC_COMPUTATION(IN_COMPUTATION_ITEM in varchar2
                           , IN_APPLICATION_ID   in number default APEX_APPLICATION.G_FLOW_ID) return varchar2 is
      L_COMPUTATION APEX_APPLICATION_COMPUTATIONS%ROWTYPE;

      L_PARAMETERS  APEX_EXEC.T_PARAMETERS;
      L_CONTEXT     APEX_EXEC.T_CONTEXT;
      L_RESULT      VCMAX;

   begin
      -- Query data for computation item
      select * into L_COMPUTATION
        from APEX_APPLICATION_COMPUTATIONS
       where COMPUTATION_ITEM = IN_COMPUTATION_ITEM
         and APPLICATION_ID = IN_APPLICATION_ID;
         
      -- Execute computation
      case L_COMPUTATION.COMPUTATION_TYPE
         when 'PLSQL_EXPRESSION' then

            APEX_EXEC.ADD_PARAMETER(L_PARAMETERS, 'BIND_OUTPUT', '');

            APEX_EXEC.EXECUTE_PLSQL(
               P_PLSQL_CODE      => ':BIND_OUTPUT := ' || L_COMPUTATION.COMPUTATION
             , P_SQL_PARAMETERS  => L_PARAMETERS
             , P_AUTO_BIND_ITEMS => TRUE
            );

            L_RESULT := APEX_EXEC.GET_PARAMETER_VARCHAR2(
                           P_PARAMETERS => L_PARAMETERS
                         , P_NAME       => 'BIND_OUTPUT'
                        );

         when 'QUERY' then
         
            begin
               L_CONTEXT := APEX_EXEC.OPEN_QUERY_CONTEXT(
                               P_LOCATION  => APEX_EXEC.C_LOCATION_LOCAL_DB
                             , P_SQL_QUERY => L_COMPUTATION.COMPUTATION);

               while APEX_EXEC.NEXT_ROW(L_CONTEXT)
               loop
                  L_RESULT := APEX_EXEC.GET_VARCHAR2(L_CONTEXT, 1);
                  null;
               end loop;

               APEX_EXEC.CLOSE(L_CONTEXT);

            exception
               when others then
                  APEX_EXEC.CLOSE(L_CONTEXT);
                  L_RESULT := SQLERRM;
            end;
            
         else
         
            null;
            
      end case;

      -- Set the ITEM Value
      APEX_UTIL.SET_SESSION_STATE(IN_COMPUTATION_ITEM, L_RESULT);

      --      return 'Type: ' || L_COMPUTATION.COMPUTATION_TYPE|| ' Result: '|| L_RESULT;
      return L_RESULT;
      
   end CALC_COMPUTATION;
