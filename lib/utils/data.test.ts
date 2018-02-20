interface IRemoteData {
    endpoint: string;
    transformation?: <T>(data: T) => T;
}

type RemoteData = { [_: string]: IRemoteData };
type GenericData = { [_: string]: any };

interface IConfig {
    remoteData?: RemoteData;
    localData?: GenericData;
    pureStatic?: boolean;
}

const config: IConfig = {
    remoteData: {
        remoteA: {
            endpoint: "https://jsonplaceholder.typicode.com/users/1",
            transformation: data => data
        },
        remoteB: {
            endpoint: "https://jsonplaceholder.typicode.com/users/2",
            transformation: data => data
        }
    },
    localData: {
        localA: "localA",
        localB: "localB",
        localC: {
            localD: "localD"
        }
    },
    pureStatic: false
};

const handleRemoteData = ({ remoteData, localData }: IConfig): GenericData => {
    if (!remoteData && localData) return localData;
    return { ...dataToPromise(remoteData), ...localData };
};

const dataToPromise = (obj: RemoteData): GenericData => {
    return { a: "a" };
};
