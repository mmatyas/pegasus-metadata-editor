package org.pegasus_frontend.metaed;

import android.content.Context;
import java.io.File;
import java.util.ArrayList;
import java.util.List;


public class MainActivity extends org.qtproject.qt5.android.bindings.QtActivity {
    private static Context m_context;

    @Override
    protected void onStart() {
        super.onStart();
        m_context = this;
    }

    public static String[] sdcardPaths() {
        final String android_subdir = "/Android/data/";

        ArrayList<String> paths = new ArrayList<String>();
        for (File file : m_context.getExternalFilesDirs(null)) {
            if (file == null)
                continue;

            final String abs_full_path = file.getAbsolutePath();
            final int substr_until = abs_full_path.indexOf(android_subdir);
            if (substr_until < 0)
                continue;

            final String abs_path = abs_full_path.substring(0, substr_until);
            paths.add(abs_path);
        }
        return paths.toArray(new String[paths.size()]);
    }
}
