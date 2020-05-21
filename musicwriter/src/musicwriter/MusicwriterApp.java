/*
 * MusicwriterApp.java
 */

package musicwriter;

import java.util.EventObject;
import org.jdesktop.application.Application;
import org.jdesktop.application.SingleFrameApplication;

/**
 * The main class of the application.
 */
public class MusicwriterApp extends SingleFrameApplication {

    private MusicwriterView view;
    /**
     * At startup create and show the main frame of the application.
     */
    @Override protected void startup() {

        ExitListener exit = new ExitListener() {

            public boolean canExit(EventObject event) {
                return view.closeConfirmation();
            }
            public void willExit(EventObject event){}
        };

        addExitListener(exit);

        view = new MusicwriterView(this);
        show(new MusicwriterView(this));
    }

    /**
     * This method is to initialize the specified window by injecting resources.
     * Windows shown in our application come fully initialized from the GUI
     * builder, so this additional configuration is not needed.
     */
    @Override protected void configureWindow(java.awt.Window root) {
    }



    
    /**
     * A convenient static getter for the application instance.
     * @return the instance of MusicwriterApp
     */
    public static MusicwriterApp getApplication() {
        return Application.getInstance(MusicwriterApp.class);
    }

    /**
     * Main method launching the application.
     */
    public static void main(String[] args) {
        launch(MusicwriterApp.class, args);
    }
}
