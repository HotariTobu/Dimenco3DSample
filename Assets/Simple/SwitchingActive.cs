using UnityEngine;

public class SwitchingActive : MonoBehaviour
{
    [SerializeField]
    GameObject Target;
    [SerializeField]
    KeyCode Trigger = KeyCode.D;

    void Update()
    {
        if (Input.GetKeyUp(Trigger))
        {
            Target.SetActive(!Target.activeInHierarchy);
        }
    }
}
