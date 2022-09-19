/**
 * @description Oracle Apex - Recalc Badge value and refresh badge in Side Navigation Menu and/or Navigation Bar Menu
 * @param {Application Item} pBadge
 * @date 2022-09-19
 */
function setBadge(pBadge) {
  // Call application process and retrive new value for badge
  apex.server.process(
    "SET_BADGE",
    {
      x01: pBadge,
    },
    {
      success: function (data) {
        // First give a litte output of calculation
        apex.debug.info(
          "Set Badge " + data.badge + " to new Value " + data.value
        );

        // Markup for Badges
        let badgeSideMenu = '<span class="a-TreeView-badge">%0</span>';

        if (data.value === "0" || data.value === undefined) {
          // For side menu remove Badge from DOM
          $("." + data.badge)
            .parent()
            .find(".a-TreeView-badge")
            .remove();

          // For navbar set value to null
          $("." + data.badge)
            .find(".t-Button-badge")
            .text("");
        } else {
          // Refesh Badge value

          // Is Badge for Side Menu
          if ($("div.a-TreeView-content>." + data.badge).length > 0) {
            apex.debug.info("Badge is for Side Menu.");

            if (
              $("div.a-TreeView-content>." + data.badge)
                .parent()
                .find("span.a-TreeView-badge").length > 0
            ) {
              // Badge is already there. Just set new value.
              $("." + data.badge)
                .parent()
                .find(".a-TreeView-badge")
                .text(data.value);
            } else {
              // Create Badge first
              $("." + data.badge)
                .parent()
                .find("a")
                .append(apex.lang.format(badgeSideMenu, data.value));
            }
          }

          // Is Badge for Navbar Menu
          if ($(".t-NavigationBar-item." + data.badge).length > 0) {
            apex.debug.info("Badge is for Navigation Bar.");
            if (
              $(".t-NavigationBar-item." + data.badge + ">a>.t-Button-badge")
                .length > 0
            ) {
              // Badge is already there. Just set new value.
              $("." + data.badge)
                .find(".t-Button-badge")
                .text(data.value);
            }
          }
        }
      },
    }
  );
}
