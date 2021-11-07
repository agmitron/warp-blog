module Controllers.Controllers
(Controller)
where
import Network.Wai
import Network.Wai.Handler.Warp
import Network.Wai.Parse


type Controller = Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
