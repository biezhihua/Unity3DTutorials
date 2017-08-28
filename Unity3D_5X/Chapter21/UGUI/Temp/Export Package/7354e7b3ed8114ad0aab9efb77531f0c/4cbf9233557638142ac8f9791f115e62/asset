using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class MenuScript : MonoBehaviour {
    public Canvas quitCanvas;
    public Button startText;
    public Button quitText;
    public GameObject mainCamera;

	// Use this for initialization
	void Start () {
        quitCanvas.enabled = false;
	}

    public void ExitPress()
    {
        quitCanvas.enabled = true;
        startText.enabled = false;
        quitText.enabled = false;
    }

    public void NoPress()
    {
        quitCanvas.enabled = false;
        startText.enabled = true;
        quitText.enabled = true;
    }

    public void StartLevel()
    {
        this.gameObject.active = false;
        quitCanvas.enabled = false;
        mainCamera.active = false;
    }

    public void ExitGame()
    {
        Application.Quit();
    }

}

