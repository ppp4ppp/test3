// GNOME Shell opens a session on the Activities overview, which leaves the full
// screen control page a thumbnail behind it until it is clicked. While the
// session starts the shell is told it has no overview, so it opens on its
// windows; once it has started the overview is its own again, Super and all.
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class NoOverviewAtStartup extends Extension {
    enable() {
        if (!Main.layoutManager._startingUp)
            return;
        this._hasOverview = Main.sessionMode.hasOverview;
        Main.sessionMode.hasOverview = false;
        this._startupId = Main.layoutManager.connect('startup-complete', () => this._restore());
    }

    disable() {
        this._restore();
    }

    _restore() {
        if (!this._startupId)
            return;
        Main.layoutManager.disconnect(this._startupId);
        this._startupId = 0;
        Main.sessionMode.hasOverview = this._hasOverview;
    }
}
