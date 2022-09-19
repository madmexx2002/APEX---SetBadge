   procedure SET_BADGE as
      L_RESULT VCMAX;
   begin
      
      -- Reclac Item Value for badge with function CALC_COMPUTATION.
      L_RESULT := CALC_COMPUTATION(IN_COMPUTATION_ITEM => APEX_APPLICATION.G_X01);

      -- Return a json with badge name (Item name) and value
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('badge', APEX_APPLICATION.G_X01);
      APEX_JSON.WRITE('value', L_RESULT);
      APEX_JSON.CLOSE_ALL;

   exception
      when others then
         APEX_JSON.OPEN_OBJECT;
         APEX_JSON.WRITE('error', 'Error while computing badge. ' || SQLERRM);
         APEX_JSON.CLOSE_ALL;
   end SET_BADGE;
